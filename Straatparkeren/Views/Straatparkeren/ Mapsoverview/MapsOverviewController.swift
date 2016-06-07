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
    static let NPA              : Int = 1
    
    var map                     : MKMapView!
    var locationManager         : CLLocationManager!
    var started                 : Bool = false
    var autocompleteTimer       : NSTimer?
    var mapItems                : [NSMapItem] = []
    var currentResultLocation   : NSMapItem?
    var isCurrentLocation       : Bool = true
    var currentPAs              : [ParkingAvailability] = []
    var currentAnnotations      : [MKAnnotation] = []
    let locationDependentCntl   : LocationDependentController = LocationDependentController.sharedInstance
    let defaultsCntrl           : DefaultsController = DefaultsController.sharedInstance
    var searchFrame             : CGRect!
    var favoritesFrame          : CGRect!
    var favoritesInTable        : Bool = false
    
    // Views
    var searchBar               : SPSearchBar?
    var navbarBtn               : SPNavButtonView?
    var navbarBtnText           : UILabel?
    let searchImg               : UIImage = UIImage(named: "SearchIcon")!.imageWithRenderingMode(.AlwaysTemplate)
    let backImg                 : UIImage = UIImage(named: "BackIcon")!.imageWithRenderingMode(.AlwaysTemplate)
    let favoriteImg             : UIImage = UIImage(named: "FavoriteIcon")!.imageWithRenderingMode(.AlwaysTemplate)
    let locationImg             : UIImage = UIImage(named: "CurrentLocationIcon")!.imageWithRenderingMode(.AlwaysTemplate)
    let destinationImg          : UIImage = UIImage(named: "LocationIcon")!.imageWithRenderingMode(.AlwaysTemplate)
    var tableView               : UITableView!
    var homeBtn                 : SPNavButtonView?
    var infoBtn                 : UIImageView!
    var infoView                : SPOverlayView?
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.clearColor()
        
        // Map init
        map = MKMapView(frame: CGRect(x: 0, y: 0, w: D.SCREEN_WIDTH, h: D.SCREEN_HEIGHT))
        map.delegate = self
        map.showsPointsOfInterest = false
        map.showsUserLocation = true
        map.setUserTrackingMode(.FollowWithHeading, animated: false)
        map.clipsToBounds = true
        map.userInteractionEnabled = false
        view.addSubview(map)
        
        homeBtn = SPNavButtonView(frame: CGRect(
            x: 0,
            y: D.NAVBAR.HEIGHT,
            w: D.NAVBAR.BTN_WIDTH + (D.SPACING.SMALL * 2),
            h: D.NAVBAR.HEIGHT
            ), image: UIImage(named: "CurrentLocationIcon")!, text: STR.map_home_btn)
        
        homeBtn!.addTapGesture(target: self, action: #selector(MapsOverviewController.homeBtnPressed))
        homeBtn!.backgroundColor = ThemeController.sharedInstance.currentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.REGULAR)
        view.addSubview(homeBtn!)
        homeBtn?.btnText?.fitWidth()
        
//        homeBtn?.btnIcon?.frame = CGRect(x: (homeBtn!.frame.width / 2)  - (homeBtn!.btnIcon!.frame.width / 2), y: homeBtn!.btnIcon!.frame.y, w: homeBtn!.btnIcon!.frame.width, h: homeBtn!.btnIcon!.frame.height)
    
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
        self.setMaximalMode()
        
        self.favoritesFrame = CGRect(
            x: D.SCREEN_WIDTH / 4,
            y: D.SCREEN_HEIGHT - D.NAVBAR.HEIGHT,
            w: D.SCREEN_WIDTH / 2,
            h: 0
        )
        
        LocationDependentController.sharedInstance.setMonitoringForRegions(CLLocationCoordinate2DMake(37.334486, -122.045596), regionSpans: [0.1, 0.3, 0.5, 1.0, 3.0])
        //        LocationDependentController.sharedInstance.setMonitoringForETAsToDestination(CLLocationCoordinate2DMake(37.333952, -122.077975), etas: [1, 4, 9, 5, 2, 1, 4, 4])
        
        let tabbar : SPTabbar = SPTabbar(frame: CGRectMake(
            self.view.frame.x,
            self.view.frame.y,
            D.SCREEN_WIDTH,
            self.view.frame.height
            ))
        
        // Tabbar gestures
        tabbar.settingsBtn.addTapGesture { (UITapGestureRecognizer) in
            let settingsVC = SettingsViewController()
            self.navigationController?.pushViewController(settingsVC, animated: false)
        }
        tabbar.searchBtn.addTapGesture(target: self, action: #selector(MapsOverviewController.toggleSearchBar))
        tabbar.favoritesBtn.addTapGesture(target: self, action: #selector(MapsOverviewController.toggleFavoritesList))
        self.view.addSubview(tabbar)
        
        let infoImg = UIImage(named: "InfoIconReverse")!.imageWithRenderingMode(.AlwaysTemplate)
        self.infoBtn = UIImageView(
            x: D.SCREEN_WIDTH - D.BTN.HEIGHT.REGULAR - D.SPACING.REGULAR,
            y: D.SCREEN_HEIGHT - D.BTN.HEIGHT.REGULAR - D.NAVBAR.HEIGHT - D.SPACING.REGULAR,
            w: D.BTN.HEIGHT.REGULAR,
            h: D.BTN.HEIGHT.REGULAR,
            image: infoImg)
        self.infoBtn.tintColor = ThemeController.sharedInstance.currentTheme().BUTTON.colorWithAlphaComponent(S.OPACITY.DARK)
        self.view.addSubview(self.infoBtn)
        self.infoBtn.addTapGesture { (UITapGestureRecognizer) in
            self.showInfoView()
        }
        
        self.view.bringSubviewToFront(homeBtn!)
        setSearchBar()
        
        self.SPNavBar?.hidden = true
        
        // Only show explanation of app on first start
        let defaults = NSUserDefaults.standardUserDefaults()
        if !defaults.boolForKey(USER_DEFAULTS.FIRST_TIME) {
            defaults.setBool(true, forKey: USER_DEFAULTS.FIRST_TIME)
            NSUserDefaults.standardUserDefaults().synchronize()
            setFirstTimeOverlay()
        }
    }
    
    func setFirstTimeOverlay(){
        let disclaimer = SPOverlayView(frame: CGRect(
            x: self.view.frame.x,
            y: self.view.frame.y,
            w: D.SCREEN_WIDTH,
            h: D.SCREEN_HEIGHT
            ), text: STR.disclaimer_text, btnText: STR.disclaimer_btn, iconImg : UIImage(named: "WarningIcon")!)
        self.view.addSubview(disclaimer)
    }
    
    func showInfoView(){
        if(self.infoView != nil){
            self.infoView?.removeFromSuperview()
            self.infoView = nil
        }
        self.infoView = SPOverlayView(frame: CGRect(
            x: D.SCREEN_WIDTH * 0.125,
            y: D.SPACING.XXLARGE,
            w: D.SCREEN_WIDTH * 0.75,
            h: D.SCREEN_HEIGHT * 0.7
            ), text: STR.explanation_text, btnText: STR.explanation_btn)
        self.infoView!.layer.cornerRadius = D.RADIUS.REGULAR
        self.infoView!.hidden = true
        self.view.addSubview(self.infoView!)
        self.infoView!.show()
    }
    
    func setSearchBar(){
        navbarBtn = SPNavButtonView(frame: CGRect(
            x: D.SCREEN_WIDTH - D.NAVBAR.BTN_WIDTH - D.SPACING.SMALL,
            y: 0,
            w: D.NAVBAR.BTN_WIDTH + D.SPACING.SMALL,
            h: D.NAVBAR.HEIGHT
            ), image: favoriteImg, text: STR.navbar_favorite_btn)
        navbarBtn?.hidden = true
        self.SPNavBar!.addSubview(navbarBtn!)
        self.view.bringSubviewToFront(SPNavBar!)
        
        searchBar = SPSearchBar(frame: CGRect(
            x: 0,
            y: 0,
            w: D.SCREEN_WIDTH - D.NAVBAR.BTN_WIDTH - D.SPACING.SMALL,
            h: D.NAVBAR.HEIGHT
            ))
        searchBar!.hidden = true
        searchBar?.delegate = self
        
        searchFrame = CGRect(
            x: 0,
            y: D.NAVBAR.HEIGHT,
            w: searchBar!.frame.width,
            h: (D.SCREEN_HEIGHT / 2) - (self.navBar?.frame.height)!
        )
        
        tableView = UITableView(frame: searchFrame, style: .Plain)
        
        tableView.registerClass(MapSearchResultViewCell.self, forCellReuseIdentifier: "SearchResultTableCell")
        tableView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = ThemeController.sharedInstance.currentTheme().TEXT.colorWithAlphaComponent(S.OPACITY.DARK)
        tableView.separatorStyle = .SingleLine
        tableView.resizeToFitHeight()
        tableView.hidden = true
        view.addSubview(tableView!)
        view.addSubview(searchBar!)
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        autocompleteTimer?.invalidate()
        autocompleteTimer = nil
        autocompleteTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(MapsOverviewController.startSearch), userInfo: nil, repeats: false)
    }
    
    func startSearch(){
        self.showmapItemsFor((searchBar?.text)!)
    }
    
    func toggleFavoritesList(){
        if(self.tableView.hidden){
            self.favoritesInTable = true
            self.mapItems = defaultsCntrl.getFavorites().reverse()
            
            if(self.mapItems.count == 0){
                self.mapItems = [NSMapItem(title: "", lat: "", long: "")]
            }
            
            self.tableView.frame = self.favoritesFrame
            self.tableView.reloadData()
            
            self.resizeTableHeight()
            self.tableView.frame = self.tableView.frame.offsetBy(dx: 0, dy: -self.tableView.contentSize.height)
        }
        self.tableView.hidden = !self.tableView.hidden
    }
    
    
    func showmapItemsFor(keyword : String){
        self.tableView.frame = self.searchFrame
        
        self.mapItems = []
        MapSearchController.sharedInstance.getNearbyPlaces(keyword, region: self.map.region, success: {resultItems -> Void in
            //limit results to 3 if greater than 3
            self.mapItems = (resultItems.count > 3) ? Array(resultItems[0..<3]) : resultItems
            
            self.tableView.reloadData()
            self.resizeTableHeight()
            self.favoritesInTable = false
            self.tableView.hidden = false
        })
        
    }
    
    func addSearchToFavorites(){
        if self.currentResultLocation != nil{
            DefaultsController.sharedInstance.addFavorite(self.currentResultLocation!)
        }
        navbarBtn?.btnIcon?.tintColor = C.FAVORITED
        navbarBtn?.btnText?.textColor = C.FAVORITED
        navbarBtn?.btnText?.text = STR.navbar_favorited_btn
        navbarBtn?.btnText?.fitWidth()
    }
    
    func toggleSearchBar(){
        removeGestureRecognizers(navbarBtn!)
        navbarBtn?.resetColors()
        if(searchBar!.hidden){
            //show
            searchBar!.hidden = false
            self.SPNavBar?.hidden = false
            searchBar!.becomeFirstResponder()
            navbarBtn?.btnIcon?.image = backImg
            navbarBtn?.btnText!.text = STR.navbar_back_btn
            navbarBtn!.addTapGesture(target: self, action: #selector(MapsOverviewController.toggleSearchBar))
            navbarBtn?.hidden = false
            setHomeBtn()
            
            
        }else{
            //hide
            searchBar!.hidden = true
            searchBar!.text = ""
            navbarBtn?.btnIcon?.image = favoriteImg
            navbarBtn?.btnText!.text = STR.navbar_favorite_btn
            navbarBtn!.addTapGesture(target: self, action: #selector(MapsOverviewController.addSearchToFavorites))
            navbarBtn?.hidden = false
            setHomeBtn()
            self.SPNavBar?.hidden = true
            mapItems = []
            tableView.reloadData()
            searchBar?.resignFirstResponder()
            resizeTableHeight()
        }
        tableView.hidden = true
    }
    
    func toggleHomeBtn(){
        homeBtn!.hidden = !homeBtn!.hidden
    }
    
    func setHomeBtn(){
        
        if self.SPNavBar!.hidden{
            homeBtn?.frame = CGRect(
                x: 0,
                y: 0,
                w: homeBtn!.btnText!.frame.width + (D.SPACING.REGULAR * 2),
                h: homeBtn!.frame.height
            )
        }else{
            homeBtn?.frame = CGRect(
                x: 0,
                y: D.NAVBAR.HEIGHT,
                w: homeBtn!.btnText!.frame.width + (D.SPACING.REGULAR * 2),
                h: homeBtn!.frame.height
            )
        }
        
        if isCurrentLocation{
            homeBtn?.btnIcon?.image = self.destinationImg
            homeBtn?.btnText?.text = STR.home_btn_destination
        }else{
            homeBtn?.btnIcon?.image = self.locationImg
            homeBtn?.btnText?.text = STR.home_btn_location
        }
        
        if self.currentResultLocation != nil{
            homeBtn?.hidden = false
        }
    }
    
    func homeBtnPressed(){
        var location : CLLocationCoordinate2D!
        if(self.isCurrentLocation){
            self.isCurrentLocation = false
            location = defaultsCntrl.getDestination()!.getCoordinate()
        }else{
            self.isCurrentLocation = true
            location = self.map.userLocation.coordinate
        }
        
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        self.SPNavBar?.setTitle("")
        self.SPNavBar?.hidden = true
        self.map.setRegion(region, animated: false)
        setHomeBtn()
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
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        if self.isCurrentLocation{
            self.map.setRegion(region, animated: true)
        }
        
        if !started{
            generateParkingAvailabilities(location!.coordinate)
            
            //            let mapRect : MKMapRect = self.map.visibleMapRect
            //            let topLeftPoint : MKMapPoint = MKMapPoint(x: MKMapRectGetMinX(mapRect), y: MKMapRectGetMinY(mapRect))
            //            let topLeftCoordinate : CLLocationCoordinate2D = MKCoordinateForMapPoint(topLeftPoint)
            //
            //            let bottomRightPoint : MKMapPoint = MKMapPoint(x: MKMapRectGetMaxX(mapRect), y: MKMapRectGetMaxY(mapRect))
            //            let bottomRightCoordinate : CLLocationCoordinate2D = MKCoordinateForMapPoint(bottomRightPoint)
            //
            //            HereAPIController.sharedInstance.trafficFlowFor(topLeftCoordinate, bottomRight: bottomRightCoordinate,  success: {(polylines) -> Void in
            //
            //                })
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
                    if polylinePoints.count > 2{
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
        return mapItems.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cellIdentifier = "SearchResultTableCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MapSearchResultViewCell
        
        // Fetch searchresult corresponding to indexpath
        let searchResult = mapItems[indexPath.row]
        
        cell.titleLabel!.text = (mapItems.count == 1 && searchResult.getTitle() == "") ? STR.search_no_results : searchResult.getTitle()
        
        cell.titleLabel!.fitHeight()
        cell.titleLabel!.frame = CGRect(x: cell.titleLabel!.frame.x, y: (D.SEARCH_CELL.HEIGHT - cell.titleLabel!.frame.height) / 2, w: tableView.frame.width - D.SPACING.REGULAR, h: cell.titleLabel!.frame.height)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return D.SEARCH_CELL.HEIGHT
    }
    
    func resizeTableHeight(){
        let height = tableView.contentSize.height

        var frame : CGRect = tableView.frame
        frame.size.height = height
        tableView.frame = frame
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let searchResult = mapItems[indexPath.row]
        
        if !favoritesInTable{
            toggleSearchBar()
            self.map.removeAnnotations(self.map.annotations)
        }else{
            toggleFavoritesList()
        }
        
        
        
        if(searchResult.getTitle() != ""){
            
            let region = MKCoordinateRegion(center: searchResult.getCoordinate(), span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
            self.currentResultLocation = searchResult
            self.SPNavBar!.setTitle(searchResult.getTitle())
            self.map.setRegion(region, animated: false)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = searchResult.getCoordinate()
            defaultsCntrl.setDestination(searchResult)
            
            self.map.addAnnotation(annotation)
            self.currentAnnotations.append(annotation)
            self.isCurrentLocation = false
            generateParkingAvailabilities(searchResult.getCoordinate())
            self.SPNavBar?.hidden = false
            setHomeBtn()
        }
        
    }
    
    func toggleTheme() {
        self.searchBar?.setNeedsDisplay()
        self.navbarBtn?.resetColors()
        self.SPNavBar!.resetColors()
        self.homeBtn?.resetColors()
        homeBtn!.backgroundColor = ThemeController.sharedInstance.currentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.DARK)
        tableView.separatorColor = ThemeController.sharedInstance.currentTheme().TEXT.colorWithAlphaComponent(S.OPACITY.DARK)
        for i in 0..<mapItems.count{
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! MapSearchResultViewCell
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
        self.setCustomToolbarHidden(true)
        
        map.removeOverlays(map.overlays)
        print(self.currentAnnotations)
        dispatch_async(dispatch_get_main_queue(), {
            self.map.addAnnotations(self.currentAnnotations)
        })
        
        renderParkingPolylines(currentPAs, snapToRoad: false, minimal: true)
    }
    
    override func setMediumMode(){
        print("minimal mode map activated")
        self.setCustomToolbarHidden(true)
        
        map.removeOverlays(map.overlays)
        dispatch_async(dispatch_get_main_queue(), {
            self.map.addAnnotations(self.currentAnnotations)
        })
        renderParkingPolylines(currentPAs, snapToRoad: false, minimal: false)
    }
    
    override func setMaximalMode(){
        print("minimal mode map activated")
        self.setCustomToolbarHidden(false)
        
        map.removeOverlays(map.overlays)
        dispatch_async(dispatch_get_main_queue(), {
            self.map.addAnnotations(self.currentAnnotations)
        })
        renderParkingPolylines(currentPAs, snapToRoad: false, minimal: false)
    }
}
