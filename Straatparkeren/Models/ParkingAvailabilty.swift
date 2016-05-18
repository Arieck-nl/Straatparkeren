//
//  ParkingAvailabilty.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 12/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import Foundation
import MapKit

class ParkingAvailability{
    
    var polylinePoints : [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var parkingState : PARKING_STATE
    
    init(polylinePoints : [CLLocationCoordinate2D], parkingState : PARKING_STATE){
        self.polylinePoints = polylinePoints
        self.parkingState = parkingState
    }
    
}
