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


// TODO: remove class if remains unused
class HereAPIController: NSObject {
    
    // Singleton instance
    static let sharedInstance = HereAPIController()
    
    typealias successHandler = (polylines:[CLLocationCoordinate2D]) -> Void
    
    func trafficFlowFor(topLeft : CLLocationCoordinate2D, bottomRight : CLLocationCoordinate2D, success : successHandler){
        
        var returnPoints : [CLLocationCoordinate2D] = []
        
        Alamofire.request(.GET, API.HERE_TRAFFIC, parameters: [
            "bbox" : topLeft.latitude.toString + "," + topLeft.longitude.toString + ";" + bottomRight.latitude.toString + "," + bottomRight.longitude.toString,
            "app_code"  : getKeyFor(K.HERE_APP_CODE),
            "app_id"    : getKeyFor(K.HERE_APP_ID)
            ])
            .validate()
            .responseJSON { response in
                                print(response.request)  // original URL request
                                print(response.response) // URL response
                                print(response.data)     // server data
                                print(response.result)   // result of response serialization
                if (response.result.value == nil){
                    return
                }
                
                if let json : JSON = JSON(response.result.value!) {
                                        print("JSON: \(json)")
                    return
                    let snappedPoints : JSON = json["snappedPoints"]
                    
                    if snappedPoints != nil{
                        var coordinates : [CLLocationCoordinate2D] = []
                        
                        for (index, point):(String, JSON) in snappedPoints {
                            let location : JSON = point["location"]
                            let coordinate = CLLocationCoordinate2DMake(location["latitude"].double!, location["longitude"].double!)
                            coordinates.append(coordinate)
                        }
                        
                        returnPoints = []
                        
                    }
                    success(polylines: returnPoints)
                }
        }
    }
}



