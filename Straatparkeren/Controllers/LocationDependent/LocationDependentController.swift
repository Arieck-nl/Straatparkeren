//
//  LocationDependentController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 02/06/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import MapKit

public enum MONITORING_TYPE : Int{
    case ETA, REGION, NOTIFICATION
}

class LocationDependentController : NSObject, CLLocationManagerDelegate {
    
    
    // Singleton instance
    static let sharedInstance = LocationDependentController()
    
    static let N_KEY            : String = N.LOCATION_TRIGGER
    static let ACCURACY         : Double = 100.0 ///meters
    
    var locationManager         : CLLocationManager!
    
    var monitorDestination      : CLLocationCoordinate2D?
    internal var monitorETAs    : [Int]?
    var monitoringTimer         : NSTimer?
    
    
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
        
        self.resetMonitoringForRegions()
    }
    
    
    /// Sets monitoring for regions
    ///
    /// - warning: distances should be a plurality of 0.1
    /// - parameter destination: precise destination for set regions
    /// - parameter regionSpans: array of spans for regions in kilometers
    func setMonitoringForRegions(destination : CLLocationCoordinate2D, regionSpans : [Double]){
        resetMonitoringForRegions()
        for rs in regionSpans {
            if (rs * 1000) % LocationDependentController.ACCURACY != 0 {
                fatalError("span must be a plurality of 0.1, span is now \(rs)")
            }
            
            let region = CLCircularRegion(center: destination, radius: (rs * 1000), identifier: rs.toString)
            region.notifyOnEntry = true
            region.notifyOnExit = false
            
            locationManager.startMonitoringForRegion(region)
        }
    }
    
    func stopMonitoringForRegions(){
        self.resetMonitoringForRegions()
    }
    
    func resetMonitoringForRegions(){
        for region in locationManager.monitoredRegions{
            locationManager.stopMonitoringForRegion(region)
        }
    }
    
    // use destination and time to destination for notifications
    // etas in minutes
    func setMonitoringForETAsToDestination(destination : CLLocationCoordinate2D, etas : [Int]){
        var filteredETAs = Array(Set(etas))
        filteredETAs = filteredETAs.sort({ $0 < $1 })
        print(filteredETAs)
        monitorETAs = filteredETAs
        monitorDestination = destination
        
        NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: #selector(self.isETALessThanSpecified), userInfo: nil, repeats: true)
        
    }
    
    func stopMonitoringForETAsToDestination(){
        monitoringTimer!.invalidate()
        monitoringTimer = nil
    }
    
    internal func isETALessThanSpecified(){
        if monitorDestination != nil && monitorETAs?.count > 0{
            let request : MKDirectionsRequest = MKDirectionsRequest()
            request.source = MKMapItem.mapItemForCurrentLocation()
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: monitorDestination!, addressDictionary: nil))
            request.transportType = .Automobile
            request.requestsAlternateRoutes = false
            
            let directions : MKDirections = MKDirections(request: request)
            directions.calculateETAWithCompletionHandler { (eta, error) in
                if(error != nil){
                    print(error)
                }else{
                    let seconds : Double = (eta?.expectedTravelTime)!
                    for (i, eta) in self.monitorETAs!.enumerate(){
                        if seconds < Double(eta*60){
                            print("Reached this eta: \(eta)")
                            self.monitorETAs!.removeRange(i...((self.monitorETAs?.count)! - 1))
                            print("Array is now: \(self.monitorETAs!)")
                            //send out notification
                            self.sentLocationTrigger(.ETA, value: eta)
                            break
                        }
                    }
                }
            }
        }
    }
    
    func sentLocationTrigger(type : MONITORING_TYPE, value : AnyObject) {
        
        let userInfo = ["type" : type.hashValue, "value" : value]
        NSNotificationCenter.defaultCenter().postNotificationName(N.LOCATION_TRIGGER, object: nil, userInfo: userInfo)
        playAppSound()
        
    }
    
    func sentDestinationTrigger(value : AnyObject) {
        
        if DefaultsController.sharedInstance.isDestinationNotificationsOn(){
            let userInfo = ["value" : value]
            NSNotificationCenter.defaultCenter().postNotificationName(N.DESTINATION_TRIGGER, object: nil, userInfo: userInfo)
            playAppSound()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print(region.identifier)
        self.sentLocationTrigger(.REGION, value: region.identifier)
    }
    
    
    
    
}


