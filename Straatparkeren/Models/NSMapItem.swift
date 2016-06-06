//
//  NSMapItem.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 05-06-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import MapKit

class NSMapItem : NSObject, NSCoding{
    
    var title   : NSString?
    var lat     : NSString?
    var long    : NSString?
    
    init(title : NSString, lat : NSString, long : NSString){
        self.title = title
        self.lat = lat
        self.long = long
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey("title") as? NSString
        let lat = aDecoder.decodeObjectForKey("lat") as? NSString
        let long = aDecoder.decodeObjectForKey("long") as? NSString
        self.init(title: title!, lat: lat!, long : long!)
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.lat, forKey: "lat")
        aCoder.encodeObject(self.long, forKey: "long")
    }
    
    func getCoordinate() -> CLLocationCoordinate2D{
        let coordinate = CLLocationCoordinate2DMake(
            Double(self.lat! as String)!, Double(self.long! as String)!
        )
        
        return coordinate
    }
    
    func getTitle() -> String{
        let value : String = self.title != nil ? String(self.title!) : ""
        return value
    }

    
}
