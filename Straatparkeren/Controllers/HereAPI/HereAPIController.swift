//
//  HereAPIController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 29-05-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class HereAPIController: NSObject {
    
    // Singleton instance
    static let sharedInstance = HereAPIController()
    
    typealias successHandler = (polyline:[CLLocationCoordinate2D]) -> Void
    
    func trafficFlowFor(location : CLLocationCoordinate2D, success : successHandler){
        
        Alamofire.request(.GET, API.GOOGLE_MAPS_ROADS, parameters: [
            "interpolate": "true",
            "path": polylineString,
            "key": getKeyFor(K.GOOGLE_MAPS_API)
            ])
            .validate()
            .responseJSON { response in
                //                print(response.request)  // original URL request
                //                print(response.response) // URL response
                //                print(response.data)     // server data
                //                print(response.result)   // result of response serialization
                if (response.result.value == nil){
                    return
                }
                
                if let json : JSON = JSON(response.result.value!) {
                    //                    print("JSON: \(json)")
                    
                    let snappedPoints : JSON = json["snappedPoints"]
                    
                    if snappedPoints != nil{
                        var coordinates : [CLLocationCoordinate2D] = []
                        
                        for (index, point):(String, JSON) in snappedPoints {
                            let location : JSON = point["location"]
                            let coordinate = CLLocationCoordinate2DMake(location["latitude"].double!, location["longitude"].double!)
                            coordinates.append(coordinate)
                        }
                        
                        returnPoints = coordinates
                        
                    }
                    success(polyline: returnPoints)
                }
        }
    }
}



