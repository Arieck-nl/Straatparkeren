//
//  MapsOverviewController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 10/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit
import MapKit
import GLKit

class MapsOverviewController: SPViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    //Number of parking availabilities to render (demo only)
    static let NPA              : Int = DD.NPA
    static let ALTITUDE         : Double = 750.0
    
    var map                     : MKMapView!
    var locationManager         : CLLocationManager!
    var started                 : Bool = false
    var autocompleteTimer       : NSTimer?
    var regionDidChangeTimer    : NSTimer?
    var trackingModeTimer       : NSTimer?
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
    var mapCamera               : MKMapCamera = MKMapCamera()
    var currentReverseGeo       : NSMapItem?
    
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
    var infoView                : SPOverlayView?
    var destinationView         : UIImageView!
    var tabbar                  : SPTabbar!
    var locationSegment         : SPSegmentedControl!
    var userAnnotation          : MKAnnotationView?
    var confirmBtn              : UILabel!
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.clearColor()
        
        // Map init
        map = MKMapView(frame: CGRect(x: 0, y: 0, w: D.SCREEN_WIDTH, h: D.SCREEN_HEIGHT))
        map.delegate = self
        map.showsPointsOfInterest = false
        map.showsUserLocation = true
        map.clipsToBounds = true
        map.scrollEnabled = true
        map.pitchEnabled = true
        map.zoomEnabled = true
        map.rotateEnabled = false
        map.multipleTouchEnabled = true
        
        mapCamera.altitude = MapsOverviewController.ALTITUDE
        
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
            locationManager.startUpdatingHeading()
            locationManager.headingFilter = 2
            willRotateToInterfaceOrientation(.LandscapeLeft, duration: 0)
        }
        
        super.viewDidLoad()
        
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
        
        self.tabbar = SPTabbar(frame: CGRectMake(
            0,
            D.SCREEN_HEIGHT - D.NAVBAR.HEIGHT,
            D.SCREEN_WIDTH,
            D.NAVBAR.HEIGHT
            ))
        
        // Tabbar gestures
        tabbar.settingsBtn.addTapGesture { (UITapGestureRecognizer) in
            let settingsVC = SettingsViewController()
            self.navigationController?.pushViewController(settingsVC, animated: true)
        }
        tabbar.searchBtn.addTapGesture(target: self, action: #selector(MapsOverviewController.toggleSearchBar))
        tabbar.favoritesBtn.addTapGesture(target: self, action: #selector(MapsOverviewController.toggleFavoritesList))
        self.view.addSubview(tabbar)
        setSearchBar()
        setConfirmBtn()
        
        self.SPNavBar?.hidden = true
        self.setCustomToolbarHidden(true)
        
        // Only show explanation of app on first start
        if  !defaultsCntrl.isFirstTimeUse() {
            defaultsCntrl.setFirstTimeUse(true)
            showInfoView()
            setFirstTimeOverlay()
        }
        
        self.view.resetColor(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setMaximalMode()
    }
    
    func setFirstTimeOverlay(){
        let disclaimer = SPOverlayView(frame: CGRect(
            x: self.view.frame.x,
            y: self.view.frame.y,
            w: D.SCREEN_WIDTH,
            h: D.SCREEN_HEIGHT
            ), text: STR.disclaimer_text, btnText: STR.disclaimer_btn, iconImg : UIImage(named: "WarningIcon")!)
        disclaimer.opacity = S.OPACITY.XXDARK
        disclaimer.resetColor(false)
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
    
    func setConfirmBtn(){
        self.confirmBtn = UILabel()
        self.confirmBtn?.textAlignment = .Center
        self.confirmBtn?.text = STR.confirm_btn
        self.confirmBtn!.font = self.confirmBtn!.font!.fontWithSize(D.FONT.XXLARGE)
        self.confirmBtn?.fitWidth()
        self.confirmBtn!.frame = CGRect(
            x: self.destinationView.frame.x + self.destinationView.frame.width + D.SPACING.SMALL,
            y: self.destinationView.frame.y,
            w: self.confirmBtn!.frame.width + (D.SPACING.REGULAR * 2),
            h: D.FONT.XXLARGE + (D.SPACING.REGULAR * 2))
        self.confirmBtn?.textColor = C.LIGHT
        self.confirmBtn?.layer.cornerRadius = D.RADIUS.SMALL
        self.confirmBtn?.clipsToBounds = true
        self.confirmBtn?.backgroundColor = C.BUTTON.DARK.colorWithAlphaComponent(S.OPACITY.XDARK)
        self.confirmBtn?.hidden = true
        self.confirmBtn.addTapGesture { _ in
            self.saveCurrentLocationAsDestination()
        }
        self.view.addSubview(self.confirmBtn!)
    }
    
    func showConfirmBtn(){
        self.confirmBtn.show()
        generateParkingAvailabilitiesForCenter()
        
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
        self.view.bringSubviewToFront(self.tableView)
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
        removeGestureRecognizers(self.navbarBtn!)
        navbarBtn?.btnIcon?.tintColor = C.FAVORITED
        navbarBtn?.btnText?.textColor = C.FAVORITED
        navbarBtn?.btnText?.text = STR.navbar_favorited_btn
        navbarBtn?.btnText?.fitWidth()
    }
    
    func addDestinationToFavorites(){
        if self.currentReverseGeo != nil{
            DefaultsController.sharedInstance.addFavorite(self.currentReverseGeo!)
        }
        removeGestureRecognizers(self.navbarBtn!)
        navbarBtn?.btnIcon?.tintColor = C.FAVORITED
        navbarBtn?.btnText?.textColor = C.FAVORITED
        navbarBtn?.btnText?.text = STR.navbar_favorited_btn
        navbarBtn?.btnText?.fitWidth()
    }
    
    func hideSearchBar(){
        //hide
        searchBar!.hidden = true
        searchBar!.text = ""
        setFavoriteForNavBtn()
        setHomeBtn()
        self.SPNavBar?.hidden = true
        mapItems = []
        tableView.reloadData()
        searchBar?.resignFirstResponder()
        resizeTableHeight()
        self.tableView.hidden = true
    }
    
    func setFavoriteForNavBtn(fromGeocoding : Bool = false){
        navbarBtn?.btnIcon?.image = favoriteImg
        navbarBtn?.btnText!.text = STR.navbar_favorite_btn
        navbarBtn?.btnText?.textAlignment = .Center
        navbarBtn?.resetColor(false)
        if fromGeocoding{
            navbarBtn!.addTapGesture(target: self, action: #selector(MapsOverviewController.addDestinationToFavorites))
        }else{
            navbarBtn!.addTapGesture(target: self, action: #selector(MapsOverviewController.addSearchToFavorites))
        }
        navbarBtn?.hidden = false
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
        }else{
            self.hideSearchBar()
        }
        setHomeBtn()
        tableView.hidden = true
    }
    
    func setHomeBtn(){
        
        if self.SPNavBar == nil{
            return
        }
        print("spnavbar: \(self.SPNavBar!.hidden) and searchbar \(self.searchBar!.hidden)")
        print((self.SPNavBar!.hidden || self.searchBar!.hidden) || (self.SPNavBar!.hidden && self.searchBar!.hidden))
        if self.SPNavBar!.hidden  || (self.SPNavBar!.hidden && self.searchBar!.hidden){
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
            self.confirmBtn.hide({ (Bool) in
            })
            self.isCurrentLocation = true
            location = self.map.userLocation.coordinate
            self.map.addAnnotations(self.currentAnnotations)
            self.destinationView.show()
        }
        
        
        self.SPNavBar?.setTitle("")
        self.hideSearchBar()
        setHomeBtn()
        self.mapCamera.centerCoordinate = location
        self.map.setCamera(self.mapCamera, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        let nextVCName = self.navigationController?.topViewController?.className
        if nextVCName == SpringboardViewController.className{
            UIView.animateWithDuration(0.75, animations: { () -> Void in
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
                UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: self.navigationController!.view, cache: false)
            })
        }
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(MKUserLocation) {
            let identifier = "UserPin"
            userAnnotation = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if userAnnotation == nil
            {
                userAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                userAnnotation!.image = UIImage(named: "LocationArrowIcon")?.resizeWithWidth(D.MAP.USER_MARKER_WIDTH)
                userAnnotation?.transform = CGAffineTransformMakeRotation(0.001)
            }
            else
            {
                userAnnotation!.annotation = annotation
            }
            
            return userAnnotation
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
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // Rotate user annotation according to heading
        self.mapCamera.heading = newHeading.trueHeading
        if self.isCurrentLocation{
            map.setCamera(self.mapCamera, animated: false)
        }
        
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        switch UIDevice.currentDevice().orientation{
        case .LandscapeLeft:
            locationManager.headingOrientation = CLDeviceOrientation.LandscapeLeft
        case .LandscapeRight:
            locationManager.headingOrientation = CLDeviceOrientation.LandscapeRight
        default:
            locationManager.headingOrientation = CLDeviceOrientation.LandscapeRight
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
        self.mapCamera.centerCoordinate = (location?.coordinate)!
        
        if self.isCurrentLocation{
            map.setCamera(self.mapCamera, animated: false)
        }
        
        
        if !started{
            generateParkingAvailabilities(location!.coordinate)
        }
        
    }
    
    func generateParkingAvailabilitiesForCenter(){
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
        
        for parkingAvailability in parkingAvailabilities{
            
            if(snapToRoad){
                self.currentPAs = []
                self.map.removeOverlays(map.overlays)
                dispatch_async(dispatch_get_main_queue(), {
                    self.map.addAnnotations(self.currentAnnotations)
                })
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
        self.confirmBtn.hide({_ in})
        
        if !favoritesInTable{
            toggleSearchBar()
            self.map.removeAnnotations(self.map.annotations)
        }else{
            toggleFavoritesList()
        }
        self.locationSegment.setSelectedFor(STR.home_btn_destination, trigger: false)
        
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
            self.locationSegment.show()
        }
        
    }
    
    //check if map interaction ended to restart collection of parking availabilities
    func didTapMap(gesture : UIGestureRecognizer){
        print("map tapped")
        self.isCurrentLocation = false
        if gesture.state == .Began{
            self.tableView.hide({_ in})
            self.destinationView.show()
            self.confirmBtn.hide({_ in})
            self.locationSegment.setSelectedFor(STR.home_btn_destination, trigger: false)
            self.locationSegment.hide({_ in})
            self.SPNavBar!.hide({_ in})
            regionDidChangeTimer?.invalidate()
            regionDidChangeTimer = nil
            
            setHomeBtn()
        } else if(gesture.state == .Ended){
            regionDidChangeTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.startReverseGeoCoding), userInfo: nil, repeats: false)
            
        }
    }
    
    func startReverseGeoCoding(){
        let location = CLLocation(latitude: self.map.centerCoordinate.latitude, longitude: self.map.centerCoordinate.longitude)
        self.setHomeBtn()
        self.locationSegment.show()
        
        MapSearchController.sharedInstance.reverseGeocodeFor(location) { (mapItem) in
            self.currentReverseGeo = mapItem
            self.SPNavBar?.setTitle(mapItem.getTitle())
            self.setFavoriteForNavBtn(true)
            self.SPNavBar?.show()
            self.showConfirmBtn()
            self.setHomeBtn()
        }
    }
    
    // Use the reverse geocoded location to save as destination
    func saveCurrentLocationAsDestination(){
        
        if self.currentReverseGeo != nil{
            self.defaultsCntrl.setDestination(self.currentReverseGeo!)
        }
        
        UIView.transitionWithView(self.confirmBtn, duration: ANI.DUR.REGULAR, options: .TransitionCrossDissolve, animations: {
            self.confirmBtn.text = STR.confirm_btn_success
            self.confirmBtn.backgroundColor = C.PRIMARY.LIGHT.colorWithAlphaComponent(S.OPACITY.XDARK)
            }, completion: { (Bool) in
                UIView.transitionWithView(self.confirmBtn, duration: ANI.DUR.REGULAR, options: .TransitionCrossDissolve, animations: {
                    }, completion: { (Bool) in
                        self.confirmBtn.hide({_ in
                            self.confirmBtn.text = STR.confirm_btn
                            self.confirmBtn.backgroundColor = C.BUTTON.DARK.colorWithAlphaComponent(S.OPACITY.XDARK)
                        })
                })
        })
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
        self.SPNavBar!.hide(ANI.DUR.GRADUALLY, completionHandler: {_ in
            self.setHomeBtn()
        })
        self.searchBar!.hide(ANI.DUR.GRADUALLY)
        self.tabbar!.hide(ANI.DUR.GRADUALLY)
        
        map.removeOverlays(map.overlays)
        dispatch_async(dispatch_get_main_queue(), {
            self.map.addAnnotations(self.currentAnnotations)
        })
        
        renderParkingPolylines(currentPAs, snapToRoad: false, minimal: true)
    }
    
    override func setMediumMode(){
        print("medium mode map activated")
        self.SPNavBar!.hide(ANI.DUR.GRADUALLY, completionHandler: {_ in
            self.setHomeBtn()
        })
        self.searchBar!.hide(ANI.DUR.GRADUALLY)
        self.tabbar!.hide(ANI.DUR.GRADUALLY)
        
        map.removeOverlays(map.overlays)
        dispatch_async(dispatch_get_main_queue(), {
            self.map.addAnnotations(self.currentAnnotations)
        })
        renderParkingPolylines(currentPAs, snapToRoad: false, minimal: false)
    }
    
    override func setMaximalMode(){
        print("maximal mode map activated")
        self.tabbar!.show(ANI.DUR.GRADUALLY)
        self.setHomeBtn()
        
        map.removeOverlays(map.overlays)
        dispatch_async(dispatch_get_main_queue(), {
            self.map.addAnnotations(self.currentAnnotations)
        })
        renderParkingPolylines(currentPAs, snapToRoad: false, minimal: false)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("maps tap")
    }
}
