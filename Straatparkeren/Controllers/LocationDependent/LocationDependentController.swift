//
//  LocationDependentController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 02/06/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import MapKit

/// Monitoring types used for sending out notifications
public enum MONITORING_TYPE : Int{
    case ETA, REGION, NOTIFICATION, OPEN
}

class LocationDependentController : NSObject, CLLocationManagerDelegate {
    
    
    // Singleton instance
    static let sharedInstance = LocationDependentController()
    
    // Notification key
    static let N_KEY            : String = N.LOCATION_TRIGGER
    
    static let ACCURACY         : Double = 100.0 ///meters
    
    var locationManager         : CLLocationManager!
    var monitorDestination      : CLLocationCoordinate2D?
    internal var monitorETAs    : [Int]?
    var monitoringTimer         : NSTimer?
    
    
    override init(){
        super.init()
        
        // Start updating gps locations
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
        
        // erase all region monitoring on start up
        self.resetMonitoringForRegions()
    }
    
    
    // Sets monitoring for regions
    //
    // - warning: distances should be a plurality of 0.1
    // - parameter destination: precise destination for set regions
    // - parameter regionSpans: array of spans for regions in kilometers
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
    // - parameter etas: etas in minutes
    func setMonitoringForETAsToDestination(destination : CLLocationCoordinate2D, etas : [Int]){
        
        // sort etas as to receive closest eta first, then dismiss others
        var filteredETAs = Array(Set(etas))
        filteredETAs = filteredETAs.sort({ $0 < $1 })
        monitorETAs = filteredETAs
        monitorDestination = destination
        
        
        // check every minute if current ETA is less than specified ETAs
        stopMonitoringForETAsToDestination()
        self.isETALessThanSpecified()
        self.monitoringTimer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: #selector(self.isETALessThanSpecified), userInfo: nil, repeats: true)
        
    }
    
    func stopMonitoringForETAsToDestination(){
        if monitoringTimer != nil{
            monitoringTimer!.invalidate()
            monitoringTimer = nil
        }
    }
    
    internal func isETALessThanSpecified(){
        if monitorDestination != nil && monitorETAs?.count > 0{
            // fetch current eta to destination
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
                    print("It will take you \(seconds) seconds to your destination")
                    
                    for (i, eta) in self.monitorETAs!.enumerate(){
                        if seconds < Double(eta*60){
                            // If this eta is less than current eta, remove larger etas from current destination range
                            self.monitorETAs!.removeRange(i...((self.monitorETAs?.count)! - 1))
                            
                            //send out notification
                            var formattedNotification = String(format: STR.notification_eta, arguments: [eta])
                            formattedNotification += eta == 1 ? STR.notification_eta_minute : STR.notification_eta_minutes
                            self.sentLocationTrigger(.NOTIFICATION, value: formattedNotification)
                            self.sentLocationTrigger(.ETA, value: eta)
                            break
                        }
                    }
                }
            }
        }
    }
    
    // sent out internal notification to listening classes
    // - parameter type: define what kind of location trigger this is
    // - parameter value: provide additional data
    func sentLocationTrigger(type : MONITORING_TYPE, value : AnyObject) {
        let userInfo = ["type" : type.hashValue, "value" : value]
        NSNotificationCenter.defaultCenter().postNotificationName(N.LOCATION_TRIGGER, object: nil, userInfo: userInfo)
        // independent of receiving class, play notification sound
        playNotificationSound()
        
    }
    
    // When user enters preset region sent out notification
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.sentLocationTrigger(.REGION, value: region.identifier)
    }
    
    
    
    
}


