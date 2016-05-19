//
//  MapsOverviewController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 10/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit
import MapKit

class MapsOverviewController: SPViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var map                 : MKMapView!
    var locationManager     : CLLocationManager!
    var started = false
    
    var searchBar           : UISearchBar?
    var searchBtn           : UIButton?
    var searchText          : UILabel?
    let searchImg           : UIImage = UIImage(named: "SearchIcon")!
    let backImg           : UIImage = UIImage(named: "BackIcon")!
    
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
        view.addSubview(searchBar!)
    }
    
    func toggleSearchBar(){
        if(searchBar!.hidden){
            searchBar!.hidden = false
            searchBar!.becomeFirstResponder()
            searchBtn?.setImage(backImg, forState: .Normal)
            searchText!.text = STR.navbar_back_btn
        }else{
            searchBar!.hidden = true
            searchBar!.text = ""
            searchBtn?.setImage(searchImg, forState: .Normal)
            searchText!.text = STR.navbar_search_btn
        }
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIView.animateWithDuration(0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: self.navigationController!.view, cache: false)
        })
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        //        if !started{
        //            let parkingLanes : [ParkingAvailability] = generateParkingAvailabilities(userLocation.coordinate)
        //            if parkingLanes.count > 0{
        //                started = true
        //                renderParkingPolylines(parkingLanes)
        //            }
        //        }
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        print(started)
        
        if !started{
            self.map.setRegion(region, animated: true)
            let parkingLanes : [ParkingAvailability] = generateParkingAvailabilities(location!.coordinate)
            if parkingLanes.count > 0{
                started = true
                renderParkingPolylines(parkingLanes)
            }
        }
    }
    
    func generateParkingAvailabilities(location : CLLocationCoordinate2D) -> [ParkingAvailability]{
        
        var parkingAvailabilities : [ParkingAvailability] = []
        
        let distanceLat : UInt32 = 3500
        let corrLat : Double = 1750.0
        let dividerLat = 1000000.0
        
        let distanceLong : UInt32 = 8000
        let corrLong : Double = 4000.0
        let dividerLong = 1000000.0
        
        
        for _ in (0..<1){
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
        return parkingAvailabilities
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
}
