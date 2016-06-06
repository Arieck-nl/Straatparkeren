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
    
    typealias responseHandler = (mapItems:[NSMapItem]) -> Void
    
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
    
    
}
