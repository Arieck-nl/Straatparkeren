//
//  MapsOverviewController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 10/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit
import MapKit

class MapsOverviewController: SPViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    //Number of parking availabilities to render (demo only)
    static let NPA              : Int = 3
    
    var map                     : MKMapView!
    var locationManager         : CLLocationManager!
    var started                 : Bool = false
    var autocompleteTimer       : NSTimer?
    var regionDidChangeTimer    : NSTimer?
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
    var infoBtn                 : UIImageView!
    var infoView                : SPOverlayView?
    var destinationView         : UIImageView!
    var tabbar                  : SPTabbar!
    var locationSegment         : SPSegmentedControl!
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.clearColor()
        
        // Map init
        map = MKMapView(frame: CGRect(x: 0, y: 0, w: D.SCREEN_WIDTH, h: D.SCREEN_HEIGHT))
        map.delegate = self
        map.showsPointsOfInterest = false
        map.showsUserLocation = true
        map.setUserTrackingMode(.FollowWithHeading, animated: true)
        map.clipsToBounds = true
        map.userInteractionEnabled = true
        map.scrollEnabled = true
        map.pitchEnabled = true
        map.zoomEnabled = true
        map.rotateEnabled = false
        map.multipleTouchEnabled = true
        
        let mapTapRecognizer : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didTapMap))
        mapTapRecognizer.delegate = self
        map.addGestureRecognizer(mapTapRecognizer)
        map.addTapGesture { (UITapGestureRecognizer) in
            self.didTapMap(UITapGestureRecognizer)
        }
        view.addSubview(map)
        self.view.bringSubviewToFront(map)
        
        self.destinationView = UIImageView(
            x: (D.SCREEN_WIDTH - D.ICON.HEIGHT.LARGE) / 2,
            y: (D.SCREEN_HEIGHT / 2) - D.ICON.HEIGHT.LARGE,
            w: D.ICON.HEIGHT.LARGE,
            h: D.ICON.HEIGHT.LARGE,
            image: destinationImg.imageWithRenderingMode(.AlwaysTemplate))
        self.destinationView.contentMode = .ScaleAspectFit
        self.destinationView.tintColor = C.MARKER
        self.destinationView.hidden = true
        self.view.addSubview(self.destinationView)
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        
        // Init map with location (later override this with user location)
        let center = CLLocationCoordinate2DMake(51.9270289, 4.4598485)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        self.map.setRegion(region, animated: true)
        
        super.viewDidLoad()
        self.setMaximalMode()
        
        self.favoritesFrame = CGRect(
            x: D.SCREEN_WIDTH / 4,
            y: D.SCREEN_HEIGHT - D.NAVBAR.HEIGHT,
            w: D.SCREEN_WIDTH / 2,
            h: 0
        )
        
        self.locationSegment = SPSegmentedControl(
            x: 0,
            y: 0,
            w: D.BTN.HEIGHT.XLARGE * 2,
            h: D.BTN.HEIGHT.XLARGE
        )
        
        self.locationSegment.setValues([STR.home_btn_location, STR.home_btn_destination],images: [locationImg, destinationImg], selected: STR.home_btn_destination)
        self.locationSegment.setOnValueChangedListerer { (value) -> Void in
            self.homeBtnPressed(value)
        }
        self.locationSegment.hidden = true
        self.view.addSubview(self.locationSegment)
        
        // TODO: Remove this, debugging and demo purposes only
        LocationDependentController.sharedInstance.setMonitoringForRegions(CLLocationCoordinate2DMake(37.334486, -122.045596), regionSpans: [0.1, 0.3, 0.5, 1.0, 3.0])
        //        LocationDependentController.sharedInstance.setMonitoringForETAsToDestination(CLLocationCoordinate2DMake(37.333952, -122.077975), etas: [1, 4, 9, 5, 2, 1, 4, 4])
        
        self.tabbar = SPTabbar(frame: CGRectMake(
            0,
            D.SCREEN_HEIGHT - D.NAVBAR.HEIGHT,
            D.SCREEN_WIDTH,
            D.NAVBAR.HEIGHT
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
        self.infoBtn.tintColor = DefaultsController.sharedInstance.getCurrentTheme().BUTTON.colorWithAlphaComponent(S.OPACITY.DARK)
        self.view.addSubview(self.infoBtn)
        self.infoBtn.addTapGesture { (UITapGestureRecognizer) in
            self.showInfoView()
        }
        
        setSearchBar()
        
        self.SPNavBar?.hidden = true
        
        // Only show explanation of app on first start
        if  !defaultsCntrl.isFirstTimeUse() {
            defaultsCntrl.setFirstTimeUse(true)
            setFirstTimeOverlay()
        }
        
        self.view.resetColor()
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
        tableView.separatorColor = DefaultsController.sharedInstance.getCurrentTheme().TEXT.colorWithAlphaComponent(S.OPACITY.DARK)
        tableView.separatorStyle = .SingleLine
        tableView.resizeToFitHeight()
        tableView.hidden = true
        view.addSubview(tableView!)
        view.addSubview(searchBar!)
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // if text did change in search bar, wait 0.3 seconds for another change, otherwise start search call
        autocompleteTimer?.invalidate()
        autocompleteTimer = nil
        autocompleteTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(MapsOverviewController.startSearch), userInfo: nil, repeats: false)
    }
    
    func startSearch(){
        self.showmapItemsFor((searchBar?.text)!)
    }
    
    func toggleFavoritesList(){
        if self.tableView.hidden{
            showFavoritesList()
        }else{
            self.tableView.hide({_ in})
        }
    }
    
    func showFavoritesList(){
        self.favoritesInTable = true
        self.mapItems = defaultsCntrl.getFavorites().reverse()
        
        if(self.mapItems.count == 0){
            self.mapItems = [NSMapItem(title: "", lat: "", long: "")]
        }
        
        self.tableView.frame = self.favoritesFrame
        self.tableView.reloadData()
        
        self.resizeTableHeight()
        self.tableView.frame = self.tableView.frame.offsetBy(dx: 0, dy: -self.tableView.contentSize.height)
        self.tableView.show()
    }
    
    // Autocomplete item search
    func showmapItemsFor(keyword : String){
        self.tableView.frame = self.searchFrame
        
        self.mapItems = []
        MapSearchController.sharedInstance.getNearbyPlaces(keyword, region: self.map.region, success: {resultItems -> Void in
            //limit results to 3 if greater than 3
            self.mapItems = (resultItems.count > 3) ? Array(resultItems[0..<3]) : resultItems
            
            if(self.mapItems.count == 0){
                self.mapItems = [NSMapItem(title: "", lat: "", long: "")]
            }
            
            self.tableView.reloadData()
            self.resizeTableHeight()
            self.favoritesInTable = false
            self.tableView.show()
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
    
    func hideSearchBar(){
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
        self.tableView.hidden = true
    }
    
    func toggleSearchBar(){
        removeGestureRecognizers(navbarBtn!)
        if(searchBar!.hidden){
            //show
            searchBar!.becomeFirstResponder()
            navbarBtn?.btnIcon?.image = backImg
            navbarBtn?.btnText!.text = STR.navbar_back_btn
            navbarBtn!.addTapGesture(target: self, action: #selector(MapsOverviewController.toggleSearchBar))
            navbarBtn?.hidden = false
            self.SPNavBar?.show()
            searchBar!.show()
            setHomeBtn()
        }else{
            self.hideSearchBar()
        }
        tableView.hidden = true
    }
    
    func setHomeBtn(){
        
        if self.SPNavBar == nil{
            return
        }
        print("\(self.SPNavBar!.hidden) and \(self.searchBar!.hidden)")
        if (self.SPNavBar!.hidden || self.searchBar!.hidden) || (self.SPNavBar!.hidden && self.searchBar!.hidden){
            self.locationSegment?.frame = CGRect(
                x: 0,
                y: 0,
                w: D.BTN.HEIGHT.XLARGE * 2,
                h: D.BTN.HEIGHT.XLARGE
            )
        }else{
            self.locationSegment?.frame = CGRect(
                x: 0,
                y: D.NAVBAR.HEIGHT,
                w: D.BTN.HEIGHT.XLARGE * 2,
                h: D.BTN.HEIGHT.XLARGE
            )
        }
    }
    
    func homeBtnPressed(value : String){
        var location : CLLocationCoordinate2D!
        if value == STR.home_btn_destination{
            self.isCurrentLocation = false
            location = defaultsCntrl.getDestination()!.getCoordinate()
            self.destinationView.show()
        }else if value == STR.home_btn_location{
            self.destinationView.hide({ (Bool) in
            })
            self.isCurrentLocation = true
            location = self.map.userLocation.coordinate
            self.map.addAnnotations(self.currentAnnotations)
            self.destinationView.show()
        }
        
        setHomeBtn()
        
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        self.SPNavBar?.setTitle("")
        self.hideSearchBar()
        self.map.setRegion(region, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Animation when view will dissapear
        // TODO: change this animation
        UIView.animateWithDuration(0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: self.navigationController!.view, cache: false)
        })
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
                annotationView!.image = UIImage.blankImage()
                annotationView?.centerOffset = CGPoint(x: 0, y: -((annotationView!.image?.size.height)! / 2))
            }
            else
            {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.map.removeAnnotations(self.map.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapView.centerCoordinate
        
        if !isCurrentLocation{
            self.map.addAnnotation(annotation)
            self.currentAnnotations.append(annotation)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        if self.isCurrentLocation{
            self.map.setRegion(region, animated: true)
        }
        
        if !started{
            generateParkingAvailabilities(location!.coordinate)
        }
    }
    
    func generateParkingAvailabilitiesForCenter(){
        defaultsCntrl.setDestination(NSMapItem(title: "", lat: self.map.centerCoordinate.latitude.toString, long: self.map.centerCoordinate.longitude.toString))
        self.generateParkingAvailabilities(nil)
    }
    
    // Randomly generate parking availability for demo purposes
    func generateParkingAvailabilities(location : CLLocationCoordinate2D?){
        var goToLocation = location
        
        // If no location is provided, use center coordinate of map
        if location == nil{
            goToLocation = self.map.centerCoordinate
        }
        
        var parkingAvailabilities : [ParkingAvailability] = []
        
        // Static values for demo purposes
        let distanceLat : UInt32 = 3500
        let corrLat : Double = 1750.0
        let dividerLat = 1000000.0
        
        let distanceLong : UInt32 = 8000
        let corrLong : Double = 4000.0
        let dividerLong = 1000000.0
        
        
        // Generate random polylines within visisble map region
        for _ in (0..<MapsOverviewController.NPA){
            let endLatInt1 = (Double(arc4random_uniform(distanceLat)) - corrLat) / dividerLat
            let endLat1 = goToLocation!.latitude - endLatInt1
            let endLongInt1 = (Double(arc4random_uniform(distanceLong)) - corrLong) / dividerLong
            let endLong1 = goToLocation!.longitude - endLongInt1
            let endLatInt2 = (Double(arc4random_uniform(distanceLat)) - corrLat) / dividerLat
            let endLat2 = goToLocation!.latitude - endLatInt2
            let endLongInt2 = (Double(arc4random_uniform(distanceLong)) - corrLong) / dividerLong
            let endLong2 = goToLocation!.longitude - endLongInt2
            
            let parkingAvailability = ParkingAvailability(polylinePoints: [
                CLLocationCoordinate2DMake(endLat1, endLong1),
                CLLocationCoordinate2DMake(endLat2, endLong2),
                ], parkingState: PARKING_STATE(rawValue: Int(arc4random_uniform(2)))!)
            
            parkingAvailabilities.append(parkingAvailability)
        }
        
        if parkingAvailabilities.count > 0{
            started = true
            renderParkingPolylines(parkingAvailabilities)
        }
    }
    
    // Generic funtion to render polylines on map
    // - parameter parkingAvailabilties: list of polylines with color
    // - parameter snapToRoad: if true, provides polylines are accurately drawn along roads
    // - parameter minimal: if true, only free parking availabilties are drawn
    func renderParkingPolylines(parkingAvailabilities : [ParkingAvailability], snapToRoad : Bool = true, minimal : Bool = false){
        self.currentPAs = []
        
        for parkingAvailability in parkingAvailabilities{
            
            if(snapToRoad){
                // Convert polylines
                GoogleAPIController.sharedInstance.snapToRoad(parkingAvailability.polylinePoints, success: {(polyline) -> Void in
                    parkingAvailability.polylinePoints = polyline
                    self.currentPAs.append(parkingAvailability)
                    
                    self.addParkingAvailabilityOverlay(parkingAvailability, minimal: minimal)
                    
                })
            }else{
                self.addParkingAvailabilityOverlay(parkingAvailability, minimal: minimal)
            }
        }
    }
    
    func addParkingAvailabilityOverlay(parkingAvailability : ParkingAvailability, minimal : Bool){
        var polylinePoints = parkingAvailability.polylinePoints
        
        // Filter out polylines that are most likely faulty (only 2 points means a straight line)
        if polylinePoints.count > 2{
            let polyOverlay = SPPolyline(coordinates: &polylinePoints[0], count: parkingAvailability.polylinePoints.count)
            polyOverlay.strokeColor = parkingAvailability.parkingState.color
            if(polyOverlay.strokeColor == C.PARKING_STATE.FREE) || !minimal{
                self.map.addOverlay(polyOverlay)
            }
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        // Define what parking polyline should look like
        let polyline : SPPolyline = overlay as! SPPolyline
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = polyline.strokeColor
        polylineRenderer.lineWidth = D.PA.THICKNESS
        
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
        self.destinationView.show()
        
        if !favoritesInTable{
            toggleSearchBar()
            self.map.removeAnnotations(self.map.annotations)
        }else{
            toggleFavoritesList()
        }
        
        if(searchResult.getTitle() != ""){
            
            // Center map on selected table row
            let region = MKCoordinateRegion(center: searchResult.getCoordinate(), span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
            self.currentResultLocation = searchResult
            self.SPNavBar!.setTitle(searchResult.getTitle())
            self.map.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = searchResult.getCoordinate()
            
            // Set as new destination
            defaultsCntrl.setDestination(searchResult)
            
            self.map.addAnnotation(annotation)
            self.currentAnnotations.append(annotation)
            self.isCurrentLocation = false
            
            // Retrieve parking availabilities for current map region
            if favoritesInTable{
                renderParkingPolylines(self.currentPAs)
            }else{
                generateParkingAvailabilities(searchResult.getCoordinate())
            }
            self.SPNavBar?.hidden = false
            setHomeBtn()
        }
        
    }
    
    //check if map interaction ended to restart collection of parking availabilities
    func didTapMap(gesture : UIGestureRecognizer){
        if gesture.state == .Began{
            self.tableView.hide({_ in})
            self.destinationView.show()
            self.isCurrentLocation = false
            self.locationSegment.setSelectedFor(STR.home_btn_destination)
            self.locationSegment.show()
            setHomeBtn()
        } else if(gesture.state == .Ended){
            regionDidChangeTimer?.invalidate()
            regionDidChangeTimer = nil
            regionDidChangeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(MapsOverviewController.saveCurrentLocationAsDestination), userInfo: nil, repeats: false)
            
        }
    }
    
    func saveCurrentLocationAsDestination(){
        generateParkingAvailabilitiesForCenter()
        defaultsCntrl.setDestination(NSMapItem(title: "", lat: self.map.centerCoordinate.latitude.toString, long: self.map.centerCoordinate.longitude.toString))
    }
    
    // Allow other gestureRecognizers to also recognize gestures of specific element
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func setDayMode(){
        self.view.resetColor()
        self.searchBar?.setNeedsDisplay()
        tableView.separatorColor = DefaultsController.sharedInstance.getCurrentTheme().TEXT.colorWithAlphaComponent(S.OPACITY.DARK)
    }
    
    override func setNightMode(){
        self.view.resetColor()
        self.searchBar?.setNeedsDisplay()
        tableView.separatorColor = DefaultsController.sharedInstance.getCurrentTheme().TEXT.colorWithAlphaComponent(S.OPACITY.DARK)
    }
    
    
    override func setMinimalMode(){
        print("minimal mode map activated")
        self.setCustomToolbarHidden(true)
        
        map.removeOverlays(map.overlays)
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
