//
//  MapsOverviewController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 10/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit
import MapKit

class MapsOverviewController: SPViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //Number of parking availabilities to render
    static let NPA          : Int = 10
    var map                 : MKMapView!
    var locationManager     : CLLocationManager!
    var started = false
    var autocompleteTimer   : NSTimer?
    
    var searchBar           : SPSearchBar?
    var searchBtn           : UIButton?
    var searchText          : UILabel?
    let searchImg           : UIImage = UIImage(named: "SearchIcon")!
    let backImg             : UIImage = UIImage(named: "BackIcon")!
    var searchTable         : UITableView!
    var searchResults       : [MKMapItem] = []
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.blackColor()
        
        // Map init
        map = MKMapView(frame: CGRect(x: 0, y: 0, w: D.SCREEN_WIDTH, h: D.SCREEN_HEIGHT))
        map.delegate = self
        map.showsPointsOfInterest = false
        map.showsUserLocation = true
        map.setUserTrackingMode(.FollowWithHeading, animated: false)
        map.clipsToBounds = true
        view.addSubview(map)
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        let center = CLLocationCoordinate2DMake(51.9270289, 4.4598485)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
        self.map.setRegion(region, animated: true)
        
        super.viewDidLoad()
        setSearchBar()
        
    }
    
    func setSearchBar(){
        searchBtn  = UIButton(frame: CGRect(x: D.SCREEN_WIDTH - D.NAVBAR.HEIGHT - D.SPACING.REGULAR, y: D.SPACING.REGULAR, w: D.NAVBAR.HEIGHT, h: D.NAVBAR.HEIGHT - (D.SPACING.REGULAR * 2)))
        searchBtn?.setImage(UIImage(named: "SearchIcon"), forState: .Normal)
        searchBtn?.imageEdgeInsets = UIEdgeInsetsMake(0, D.SPACING.REGULAR, D.SPACING.SMALL + D.FONT.XXLARGE, D.SPACING.REGULAR)
        searchBtn?.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        searchBtn!.addTapGesture(target: self, action: #selector(MapsOverviewController.toggleSearchBar))
        self.view.addSubview(searchBtn!)
        
        searchText = UILabel(frame: CGRect(x: (searchBtn?.frame.x)!, y: searchBtn!.frame.y + searchBtn!.frame.height - D.FONT.XXLARGE, w: searchBtn!.frame.width, h: 100))
        searchText!.text = STR.navbar_search_btn
        searchText?.textColor = C.TEXT
        searchText!.textAlignment = .Center
        searchText?.font = searchText?.font.fontWithSize(D.FONT.XXLARGE)
        searchText!.fitHeight()
        self.view.addSubview(searchText!)
        
        
        searchBar = SPSearchBar(frame: CGRect(x: 0, y: 0, w: (searchBtn?.frame.x)! - D.SPACING.REGULAR, h: D.NAVBAR.HEIGHT))
        searchBar!.hidden = true
        searchBar?.delegate = self
        
        searchTable = UITableView(frame: CGRect(x: 0, y: D.NAVBAR.HEIGHT, w: searchBar!.frame.width, h: (D.SCREEN_HEIGHT / 2) - (self.navBar?.frame.height)!), style: .Plain)
        searchTable.registerClass(MapSearchResultViewCell.self, forCellReuseIdentifier: "SearchResultTableCell")
        searchTable.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        searchTable.delegate = self
        searchTable.dataSource = self
        searchTable.separatorColor = C.TEXT.colorWithAlphaComponent(S.OPACITY.DARK)
        searchTable.separatorStyle = .SingleLine
        searchTable.resizeToFitHeight()
        view.addSubview(searchTable!)
        view.addSubview(searchBar!)
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        autocompleteTimer?.invalidate()
        autocompleteTimer = nil
        autocompleteTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(MapsOverviewController.startSearch), userInfo: nil, repeats: false)
    }
    
    func startSearch(){
        self.showSearchResultsFor((searchBar?.text)!)
    }
    
    
    func showSearchResultsFor(keyword : String){
        searchResults = []
        
        MapSearchController.sharedInstance.getNearbyPlaces(keyword, region: self.map.region, success: {mapItems -> Void in
            //limit results to 3 if greater than 3
            self.searchResults = (mapItems.count > 3) ? Array(mapItems[0..<3]) : mapItems
            if(self.searchResults.count == 0){
                self.searchResults = [MKMapItem()]
            }
            self.searchTable.reloadData()
            self.resizeTableHeight()
        })
        
        print(keyword)
    }
    
    func toggleSearchBar(){
        if(searchBar!.hidden){
            //show
            searchBar!.hidden = false
            searchBar!.becomeFirstResponder()
            searchBtn?.setImage(backImg, forState: .Normal)
            searchText!.text = STR.navbar_back_btn
            
        }else{
            //hide
            searchBar!.hidden = true
            searchBar!.text = ""
            searchBtn?.setImage(searchImg, forState: .Normal)
            searchText!.text = STR.navbar_search_btn
            searchResults = []
            searchTable.reloadData()
            searchBar?.resignFirstResponder()
            resizeTableHeight()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIView.animateWithDuration(0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: self.navigationController!.view, cache: false)
        })
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        //        if !started{
        //                    generateParkingAvailabilities(userLocation.coordinate)
        //        }
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        print(started)
        
        if !started{
            self.map.setRegion(region, animated: false)
            generateParkingAvailabilities(location!.coordinate)
        }
    }
    
    
    func generateParkingAvailabilities(location : CLLocationCoordinate2D){
        
        var parkingAvailabilities : [ParkingAvailability] = []
        
        let distanceLat : UInt32 = 3500
        let corrLat : Double = 1750.0
        let dividerLat = 1000000.0
        
        let distanceLong : UInt32 = 8000
        let corrLong : Double = 4000.0
        let dividerLong = 1000000.0
        
        
        for _ in (0..<MapsOverviewController.NPA){
            let endLatInt1 = (Double(arc4random_uniform(distanceLat)) - corrLat) / dividerLat
            let endLat1 = location.latitude - endLatInt1
            let endLongInt1 = (Double(arc4random_uniform(distanceLong)) - corrLong) / dividerLong
            let endLong1 = location.longitude - endLongInt1
            let endLatInt2 = (Double(arc4random_uniform(distanceLat)) - corrLat) / dividerLat
            let endLat2 = location.latitude - endLatInt2
            let endLongInt2 = (Double(arc4random_uniform(distanceLong)) - corrLong) / dividerLong
            let endLong2 = location.longitude - endLongInt2
            
            let parkingAvailability = ParkingAvailability(polylinePoints: [
                CLLocationCoordinate2DMake(endLat1, endLong1),
                CLLocationCoordinate2DMake(endLat2, endLong2),
                ], parkingState: PARKING_STATE(rawValue: Int(arc4random_uniform(3)))!)
            //
            //            for coordinate in parkingAvailability.polylinePoints{
            //                let ann = MKPointAnnotation()
            //                ann.coordinate = coordinate
            //                self.map.addAnnotation(ann)
            //            }
            
            parkingAvailabilities.append(parkingAvailability)
        }
        
        if parkingAvailabilities.count > 0{
            started = true
            renderParkingPolylines(parkingAvailabilities)
        }
    }
    
    func renderParkingPolylines(parkingAvailabilities : [ParkingAvailability]){
        for parkingAvailability in parkingAvailabilities{
            
            GoogleAPIController.sharedInstance.snapToRoad(parkingAvailability.polylinePoints, success: {(polyline) -> Void in
                var polylinePoints = polyline
                if polylinePoints.count > 1{
                    let polyOverlay = SPPolyline(coordinates: &polylinePoints[0], count: parkingAvailability.polylinePoints.count)
                    polyOverlay.strokeColor = parkingAvailability.parkingState.color
                    self.map.addOverlay(polyOverlay)
                }
                
            })
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        let polyline : SPPolyline = overlay as! SPPolyline
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = polyline.strokeColor
        polylineRenderer.lineWidth = 10
        
        return polylineRenderer
    }
    
    
    /* ----------- Search Table View ------------- */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return searchResults.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cellIdentifier = "SearchResultTableCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MapSearchResultViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let searchResult = searchResults[indexPath.row]
        
        cell.titleLabel!.text = (searchResults.count == 1 && searchResult.placemark.title == nil) ? STR.search_no_results : searchResult.placemark.title!
        
        cell.titleLabel!.fitHeight()
        cell.titleLabel!.frame = CGRect(x: cell.titleLabel!.frame.x, y: (D.SEARCH_CELL.HEIGHT - cell.titleLabel!.frame.height) / 2, w: searchTable!.frame.width - D.SPACING.REGULAR, h: cell.titleLabel!.frame.height)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return D.SEARCH_CELL.HEIGHT
    }
    
    func resizeTableHeight(){
        var height = searchTable.contentSize.height
        let maxHeight = searchTable.superview!.frame.size.height - searchTable.frame.origin.y
        
        if (height > maxHeight){
            height = maxHeight
        }
        var frame : CGRect = searchTable.frame
        frame.size.height = height
        searchTable.frame = frame
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let searchResult = searchResults[indexPath.row]
        toggleSearchBar()
        
        let region = MKCoordinateRegion(center: searchResult.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        
        self.map.setRegion(region, animated: false)
        generateParkingAvailabilities(searchResult.placemark.coordinate)
    }
}
