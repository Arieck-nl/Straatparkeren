//
//  GoogleAPIController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 17/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class GoogleAPIController: NSObject {
    
    // Singleton instance
    static let sharedInstance = GoogleAPIController()
    
    // Shorthand for successHandler
    typealias polylineHandler = (polyline:[CLLocationCoordinate2D]) -> Void
    
    
    // Provide polyline to get polyline alongside roads
    // - parameter polylinePoints: polyline coordinates to convert to snapToRoads polyline
    // - parameter success: success handler to process returned polylines
    func snapToRoad(polylinePoints : [CLLocationCoordinate2D], success : polylineHandler){
        
        var polylineString = ""
        var returnPoints : [CLLocationCoordinate2D] = []
        
        // Create formatted polyline string parameter
        for polylinePoint in polylinePoints{
            polylineString += polylinePoint.latitude.toString + "," + polylinePoint.longitude.toString + "|"
        }
        
        polylineString = String(polylineString.characters.dropLast())        
        
        // Set up request for maps API (see constants for parameters)
        Alamofire.request(.GET, API.GOOGLE_MAPS_ROADS, parameters: [
            "interpolate": "true",
            "path": polylineString,
            "key": getKeyFor(K.GOOGLE_MAPS_API)
            ])
            .validate()
            .responseJSON { response in
                if (response.result.value == nil){
                    return
                }
                
                if let json : JSON = JSON(response.result.value!) {
                    
                    let snappedPoints : JSON = json["snappedPoints"]
                    
                    if snappedPoints != nil{
                        var coordinates : [CLLocationCoordinate2D] = []
                        
                        for (_, point):(String, JSON) in snappedPoints {
                            let location : JSON = point["location"]
                            let coordinate = CLLocationCoordinate2DMake(location["latitude"].double!, location["longitude"].double!)
                            coordinates.append(coordinate)
                        }
                        
                        returnPoints = coordinates
                        
                    }
                    // Return new polyline
                    success(polyline: returnPoints)
                }
        }
    }
}


