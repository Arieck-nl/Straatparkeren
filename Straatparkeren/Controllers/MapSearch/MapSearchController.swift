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
    
    typealias responseHandler = (mapItems:[MKMapItem]) -> Void
    
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
            
            success(mapItems: response.mapItems)
        }
    }
    
    
}
