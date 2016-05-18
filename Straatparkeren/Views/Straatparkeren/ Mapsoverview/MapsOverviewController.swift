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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        // Map init
        map = MKMapView(frame: view.frame)
        map.delegate = self
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
        
        //        var parkingLanes : [ParkingAvailability] = []
        //        parkingLanes.append(ParkingAvailability(polylinePoints: [
        //            CLLocationCoordinate2DMake(51.9260289, 4.4538485),
        //            CLLocationCoordinate2DMake(51.9280289, 4.4568485)
        //            ], parkingState: PARKING_STATE.FREE))
        //        parkingLanes.append(ParkingAvailability(polylinePoints: [
        //            CLLocationCoordinate2DMake(51.9270289, 4.4538485),
        //            CLLocationCoordinate2DMake(51.9280289, 4.4548485),
        //            CLLocationCoordinate2DMake(51.9290289, 4.4558685)
        //            ], parkingState: PARKING_STATE.SEMI_FULL))
        //        parkingLanes.append(ParkingAvailability(polylinePoints: [
        //            CLLocationCoordinate2DMake(51.9160289, 4.4596485),
        //            CLLocationCoordinate2DMake(51.9160289, 4.4598485)
        //            ], parkingState: PARKING_STATE.FULL))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIView.animateWithDuration(0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: self.navigationController!.view, cache: false)
        })
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        let parkingLanes : [ParkingAvailability] = generateParkingAvailabilities(userLocation.coordinate)
        if parkingLanes.count > 0{
            renderParkingPolylines(parkingLanes)
        }
        
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
        
        
        for i in (0..<1){
            let endLatInt1 = (Double(arc4random_uniform(distanceLat)) - corrLat) / dividerLat
            let endLat1 = location.latitude - endLatInt1
            let endLongInt1 = (Double(arc4random_uniform(distanceLong)) - corrLong) / dividerLong
            let endLong1 = location.longitude - endLongInt1
            let endLatInt2 = (Double(arc4random_uniform(distanceLat)) - corrLat) / dividerLat
            let endLat2 = location.latitude - endLatInt2
            let endLongInt2 = (Double(arc4random_uniform(distanceLong)) - corrLong) / dividerLong
            let endLong2 = location.longitude - endLongInt2
            let endLatInt3 = (Double(arc4random_uniform(distanceLat)) - corrLat) / dividerLat
            let endLat3 = location.latitude - endLatInt3
            let endLongInt3 = (Double(arc4random_uniform(distanceLong)) - corrLong) / dividerLong
            let endLong3 = location.longitude - endLongInt3
            
            let parkingAvailability = ParkingAvailability(polylinePoints: [
                CLLocationCoordinate2DMake(endLat1, endLong1),
                CLLocationCoordinate2DMake(endLat2, endLong2),
//                CLLocationCoordinate2DMake(endLat3, endLong3),
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
        var polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = polyline.strokeColor
        polylineRenderer.lineWidth = 10
        return polylineRenderer
    }
}
