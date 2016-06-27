//
//  MapSearchController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 19/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit
import MapKit


class MapSearchController: NSObject {
    
    // Singleton instance
    static let sharedInstance = MapSearchController()
    internal static let geocoder = CLGeocoder()
    
    typealias responseHandler = (mapItems:[NSMapItem]) -> Void
    
    // Get places for given keyword
    // - parameter keyword: location keyword to search for
    // - parameter region: provide region to search in (this doesn't actually work internally)
    // - parameter success: handler for results
    func getNearbyPlaces(keyword : String, region : MKCoordinateRegion, success : responseHandler) {
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = keyword
        request.region = region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {
                success(mapItems: [])
                return
            }
            
            var mapItems : [NSMapItem] = []
            
            for mapItem in response.mapItems{
                mapItems.append(NSMapItem(
                    title: mapItem.placemark.title!,
                    lat: mapItem.placemark.coordinate.latitude.toString,
                    long: mapItem.placemark.coordinate.longitude.toString
                    ))
            }
            
            success(mapItems: mapItems)
        }
        
    }
    
    // Get places for given location
    // - parameter location: location to search for
    // - parameter success: handler for results
    func reverseGeocodeFor(location : CLLocation, success : (mapItem:NSMapItem) -> Void){
        
        MapSearchController.geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil{
                return
            }
            let placemark : CLPlacemark = placemarks![0]
            let mapItem = NSMapItem(
                title: placemark.name! + ", " + placemark.subAdministrativeArea!,
                lat: (placemark.location?.coordinate.latitude.toString)!,
                long: (placemark.location?.coordinate.longitude.toString)!
            )
            
            success(mapItem: mapItem)
        }
        
    }
    
    
}
