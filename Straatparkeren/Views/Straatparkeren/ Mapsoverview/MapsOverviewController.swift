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
    static let NPA          : Int = 1
    
    var map                 : MKMapView!
    var locationManager     : CLLocationManager!
    var started = false
    var autocompleteTimer   : NSTimer?
    var searchResults       : [MKMapItem] = []
    var isCurrentLocation   : Bool = true
    var currentPAs          : [ParkingAvailability] = []
    var currentAnns         : [MKAnnotation] = []
    
    // Views
    var searchBar           : SPSearchBar?
    var navbarBtn           : SPNavButtonView?
    var navbarBtnText       : UILabel?
    let searchImg           : UIImage = UIImage(named: "SearchIcon")!.imageWithRenderingMode(.AlwaysTemplate)
    let backImg             : UIImage = UIImage(named: "BackIcon")!.imageWithRenderingMode(.AlwaysTemplate)
    var searchTable         : UITableView!
    var homeBtn             : SPNavButtonView?
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.blackColor()
        
        // Map init
        map = MKMapView(frame: CGRect(x: 0, y: 0, w: D.SCREEN_WIDTH, h: D.SCREEN_HEIGHT))
        map.delegate = self
        map.showsPointsOfInterest = false
        map.showsUserLocation = true
        map.setUserTrackingMode(.FollowWithHeading, animated: false)
        map.clipsToBounds = true
        map.userInteractionEnabled = false
        view.addSubview(map)
        
        homeBtn = SPNavButtonView(frame: CGRect(x: D.SCREEN_WIDTH -  D.NAVBAR.HEIGHT - (D.SPACING.SMALL * 2), y: D.SCREEN_HEIGHT - D.NAVBAR.HEIGHT, w: D.NAVBAR.HEIGHT + (D.SPACING.SMALL * 2), h: D.NAVBAR.HEIGHT), image: UIImage(named: "CurrentLocationIcon")!, text: STR.map_home_btn)
        homeBtn!.addTapGesture(target: self, action: #selector(MapsOverviewController.goToUserLocation))
        homeBtn!.backgroundColor = ThemeController.sharedInstance.currentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.DARK)
        view.addSubview(homeBtn!)
        homeBtn?.btnText?.fitWidth()
        homeBtn?.frame = CGRect(x: D.SCREEN_WIDTH - homeBtn!.btnText!.frame.width - (D.SPACING.REGULAR * 2), y: homeBtn!.frame.y, w: homeBtn!.btnText!.frame.width + (D.SPACING.REGULAR * 2), h: homeBtn!.frame.height)
        homeBtn?.btnIcon?.frame = CGRect(x: (homeBtn!.frame.width / 2)  - (homeBtn!.btnIcon!.frame.width / 2), y: homeBtn!.btnIcon!.frame.y, w: homeBtn!.btnIcon!.frame.width, h: homeBtn!.btnIcon!.frame.height)
        toggleHomeBtn()
        
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
        
        // Only show explanation of app on first start
        let defaults = NSUserDefaults.standardUserDefaults()
        if !defaults.boolForKey(USER_DEFAULTS.FIRST_TIME) {
            defaults.setBool(true, forKey: USER_DEFAULTS.FIRST_TIME)
            NSUserDefaults.standardUserDefaults().synchronize()
            setFirstTimeOverlay()
        }
        
        self.setMinimalMode()
        
    }
    
    func setFirstTimeOverlay(){
        let overlay = SPOverlayView(frame: self.view.frame, text: STR.explanation_text, btnText: STR.explanation_btn)
        self.view.addSubview(overlay)
    }
    
    func setSearchBar(){
        navbarBtn = SPNavButtonView(frame: CGRect(x: D.SCREEN_WIDTH -  D.NAVBAR.HEIGHT - (D.SPACING.SMALL * 2), y: 0, w: D.NAVBAR.HEIGHT + (D.SPACING.SMALL * 2), h: D.NAVBAR.HEIGHT), image: UIImage(named: "SearchIcon")!, text: STR.navbar_search_btn)
        navbarBtn!.addTapGesture(target: self, action: #selector(MapsOverviewController.toggleSearchBar))
        self.view.addSubview(navbarBtn!)
        
        
        searchBar = SPSearchBar(frame: CGRect(x: 0, y: 0, w: (navbarBtn?.frame.x)!, h: D.NAVBAR.HEIGHT))
        searchBar!.hidden = true
        searchBar?.delegate = self
        
        searchTable = UITableView(frame: CGRect(x: 0, y: D.NAVBAR.HEIGHT, w: searchBar!.frame.width, h: (D.SCREEN_HEIGHT / 2) - (self.navBar?.frame.height)!), style: .Plain)
        searchTable.registerClass(MapSearchResultViewCell.self, forCellReuseIdentifier: "SearchResultTableCell")
        searchTable.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        searchTable.delegate = self
        searchTable.dataSource = self
        searchTable.separatorColor = ThemeController.sharedInstance.currentTheme().TEXT.colorWithAlphaComponent(S.OPACITY.DARK)
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
            navbarBtn?.btnIcon?.image = backImg
            navbarBtn?.btnText!.text = STR.navbar_back_btn
            
        }else{
            //hide
            searchBar!.hidden = true
            searchBar!.text = ""
            navbarBtn?.btnIcon?.image = searchImg
            navbarBtn?.btnText!.text = STR.navbar_search_btn
            searchResults = []
            searchTable.reloadData()
            searchBar?.resignFirstResponder()
            resizeTableHeight()
        }
    }
    
    func toggleHomeBtn(){
        if(homeBtn!.hidden){
            //show
            homeBtn!.hidden = false
        }else{
            //hide
            homeBtn!.hidden = true
        }
    }
    
    func goToUserLocation(){
        self.map.removeAnnotations(self.map.annotations)
        let location = self.map.userLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        self.SPNavBar?.setTitle("")
        self.map.setRegion(region, animated: false)
        toggleHomeBtn()
        
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
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation.isKindOfClass(MKUserLocation) {
            let identifier = "UserPin"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil
            {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.image = UIImage(named: "LocationArrowIcon")?.resizeWithWidth(D.MAP.USER_MARKER_WIDTH)
            }
            else
            {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        else{
            let identifier = "LocationPin"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil
            {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.image = UIImage(named: "LocationIcon")
                annotationView?.centerOffset = CGPoint(x: 0, y: -((annotationView!.image?.size.height)! / 2))
            }
            else
            {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        
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
    
    func renderParkingPolylines(parkingAvailabilities : [ParkingAvailability], snapToRoad : Bool = true, minimal : Bool = false){
        for parkingAvailability in parkingAvailabilities{
            
            if(snapToRoad){
                GoogleAPIController.sharedInstance.snapToRoad(parkingAvailability.polylinePoints, success: {(polyline) -> Void in
                    var polylinePoints = polyline
                    parkingAvailability.polylinePoints = polylinePoints
                    self.currentPAs.append(parkingAvailability)
                    if polylinePoints.count > 1{
                        let polyOverlay = SPPolyline(coordinates: &polylinePoints[0], count: parkingAvailability.polylinePoints.count)
                        polyOverlay.strokeColor = parkingAvailability.parkingState.color
                        if(minimal && polyOverlay.strokeColor == C.PARKING_STATE.FREE){
                            self.map.addOverlay(polyOverlay)
                        } else if(!minimal){
                            self.map.addOverlay(polyOverlay)
                        }
                    }
                    
                })
            }else{
                var polylinePoints = parkingAvailability.polylinePoints
                if polylinePoints.count > 1{
                    let polyOverlay = SPPolyline(coordinates: &polylinePoints[0], count: parkingAvailability.polylinePoints.count)
                    polyOverlay.strokeColor = parkingAvailability.parkingState.color
                    if(minimal && polyOverlay.strokeColor == C.PARKING_STATE.FREE){
                        self.map.addOverlay(polyOverlay)
                    } else if(!minimal){
                        self.map.addOverlay(polyOverlay)
                    }
                }
            }
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
        
        // Fetch searchresult corresponding to indexpath
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
        
        
        if(searchResult.placemark.name != nil){
            let region = MKCoordinateRegion(center: searchResult.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
            self.SPNavBar!.setTitle(searchResult.placemark.title!)
            self.map.setRegion(region, animated: false)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = searchResult.placemark.coordinate
            
            self.map.addAnnotation(annotation)
            self.currentAnns.append(annotation)
            isCurrentLocation = false
            generateParkingAvailabilities(searchResult.placemark.coordinate)
            toggleHomeBtn()
        }
        
    }
    
    func toggleTheme() {
        self.searchBar?.setNeedsDisplay()
        self.navbarBtn?.resetColors()
        self.SPNavBar!.resetColors()
        self.homeBtn?.resetColors()
        homeBtn!.backgroundColor = ThemeController.sharedInstance.currentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.DARK)
        searchTable.separatorColor = ThemeController.sharedInstance.currentTheme().TEXT.colorWithAlphaComponent(S.OPACITY.DARK)
        for i in 0..<searchResults.count{
            let cell = self.searchTable.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! MapSearchResultViewCell
            cell.resetColors()
        }
    }
    
    override func setDayMode(){
        toggleTheme()
    }
    
    override func setNightMode(){
        toggleTheme()
    }
    
    
    override func setMinimalMode(){
        print("minimal mode map activated")
        searchBar?.hidden = true
        
        map.removeOverlays(map.overlays)
        print(self.currentAnns)
        dispatch_async(dispatch_get_main_queue(), {
            self.map.addAnnotations(self.currentAnns)
        })
        
        renderParkingPolylines(currentPAs, snapToRoad: false, minimal: true)
    }
    
    override func setMediumMode(){
        print("minimal mode map activated")
        searchBar?.hidden = true
        
        map.removeOverlays(map.overlays)
        dispatch_async(dispatch_get_main_queue(), {
            self.map.addAnnotations(self.currentAnns)
        })
        renderParkingPolylines(currentPAs, snapToRoad: false, minimal: false)
    }
    
    override func setMaximalMode(){
        print("minimal mode map activated")
        searchBar?.hidden = false
        
        map.removeOverlays(map.overlays)
        dispatch_async(dispatch_get_main_queue(), {
            self.map.addAnnotations(self.currentAnns)
        })
        renderParkingPolylines(currentPAs, snapToRoad: false, minimal: true)
    }
}
