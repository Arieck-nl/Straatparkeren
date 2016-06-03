//
//  LocationDependentController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 02/06/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import MapKit

class LocationDependentController : NSObject, CLLocationManagerDelegate {
    
    
    // Singleton instance
    static let sharedInstance = LocationDependentController()
    
    static let ACCURACY : Double = 100.0
    
    var locationManager : CLLocationManager!
    
    
    override init(){
        super.init()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
    }
    
    
    /// Sets monitoring for regions
    ///
    /// - warning: distances should be a plurality of 100.0
    /// - parameter destination: precise destination for set regions
    /// - parameter regionSpans: array of spans for regions
    func setMonitoringForRegions(destination : CLLocation, regionSpans : [Double]){
        
        for rs in regionSpans {
            if rs % LocationDependentController.ACCURACY != 0 {
                fatalError("span must be a plurality of 100.0")
            }
            let region = CLCircularRegion(center: destination.coordinate, radius: rs, identifier: rs.toString)
            
            locationManager.startMonitoringForRegion(region)
        }
    }
    
    // use destination and time to destination for notifications
    func setMonitoringForETAsToDestination(destination : CLLocation, etas : [Double]){
//        MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
//        [request setSource:[MKMapItem mapItemForCurrentLocation]];
//        [request setDestination:destination];
//        [request setTransportType:MKDirectionsTransportTypeAutomobile];
//        [request setRequestsAlternateRoutes:NO];
//        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
//        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
//        if ( ! error && [response routes] > 0) {
//        MKRoute *route = [[response routes] objectAtIndex:0];
//        //route.distance  = The distance
//        //route.expectedTravelTime = The ETA
//        }
//        }];
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print(region.identifier)
        
    }
    
    
    
}


