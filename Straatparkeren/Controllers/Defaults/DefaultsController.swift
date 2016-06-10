//
//  DefaultsController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 05-06-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import Foundation
import MapKit

class DefaultsController : NSObject{
    
    // Singleton instance
    static let sharedInstance = DefaultsController()
    
    static let maxFavorites = 5
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func isFirstTimeUse() -> Bool{
        return defaults.boolForKey(USER_DEFAULTS.FIRST_TIME)
    }
    
    func setFirstTimeUse(value : Bool){
        defaults.setBool(value, forKey: USER_DEFAULTS.FIRST_TIME)
        defaults.synchronize()
        
    }
    
    
    func isInSafetyMode() -> Bool{
        let safetyMode = defaults.boolForKey(USER_DEFAULTS.SAFETY_MODE)
        return safetyMode
    }
    
    func toggleSafetyMode(){
        let safetyMode = isInSafetyMode()
        defaults.setBool(!safetyMode, forKey: USER_DEFAULTS.SAFETY_MODE)
        defaults.synchronize()
    }
    
    func isAutomaticShutdownOn() -> Bool{
        let shutdown = defaults.boolForKey(USER_DEFAULTS.AUTOMATIC_SHUTDOWN)
        return shutdown
    }
    
    func toggleAutomaticShutdown(){
        let shutdown = isAutomaticShutdownOn()
        defaults.setBool(!shutdown, forKey: USER_DEFAULTS.AUTOMATIC_SHUTDOWN)
        defaults.synchronize()
    }
    
    func isDestinationNotificationsOn() -> Bool{
        let isOn = defaults.boolForKey(USER_DEFAULTS.DESTINATION_NOTIFICATION)
        return isOn
    }
    
    func toggleDestinationNotification(){
        let isOn = isDestinationNotificationsOn()
        defaults.setBool(!isOn, forKey: USER_DEFAULTS.DESTINATION_NOTIFICATION)
        defaults.synchronize()
    }
    
    func getLocationNotificationDistances() -> [Double]{
        var items : [Double] = []
        if let decodedObject : NSData = NSUserDefaults.standardUserDefaults().objectForKey(USER_DEFAULTS.LOCATION_NOTIFICATION) as? NSData{
            let distances = NSKeyedUnarchiver.unarchiveObjectWithData(decodedObject) as! [Double]
            
            items = distances
        }
        return items
    }
    
    func setLocationNotificationDistances(distances : [Double]){
        let encodedObject : NSData = NSKeyedArchiver.archivedDataWithRootObject(distances as NSArray)
        
        defaults.setObject(encodedObject, forKey: USER_DEFAULTS.LOCATION_NOTIFICATION)
        defaults.synchronize()
        
        let savedDistances = getLocationNotificationDistances()
        let destination = getDestination()
        if savedDistances.count > 0 && destination != nil{
            LocationDependentController.sharedInstance.setMonitoringForRegions((destination?.getCoordinate())!, regionSpans: savedDistances)
        }
        else{
            LocationDependentController.sharedInstance.stopMonitoringForRegions()
        }
        
        print(getLocationNotificationDistances())
    }
    
    func setDestination(destination : NSMapItem){
        let encodedObject : NSData = NSKeyedArchiver.archivedDataWithRootObject(destination)
        
        defaults.setObject(encodedObject, forKey: USER_DEFAULTS.CURRENT_DESTINATION)
        defaults.synchronize()
        
        self.setLocationNotificationDistances(self.getLocationNotificationDistances())
    }
    
    func getDestination() -> NSMapItem?{
        var destination : NSMapItem?
        if let decodedObject : NSData = NSUserDefaults.standardUserDefaults().objectForKey(USER_DEFAULTS.CURRENT_DESTINATION) as? NSData{
            destination = NSKeyedUnarchiver.unarchiveObjectWithData(decodedObject) as? NSMapItem
            
        }
        return destination
    }
    
    func addFavorite(favorite : NSMapItem){
        var favorites = getFavorites()
        
        favorites = (favorites.count >= DefaultsController.maxFavorites) ? Array(favorites[1..<DefaultsController.maxFavorites]) : favorites
        
        favorites.append(favorite)
        
        let encodedObject : NSData = NSKeyedArchiver.archivedDataWithRootObject(favorites as NSArray)
        
        defaults.setObject(encodedObject, forKey: USER_DEFAULTS.FAVORITES)
        defaults.synchronize()
    }
    
    func getFavorites() -> [NSMapItem]{
        var items : [NSMapItem] = []
        if let decodedObject : NSData = NSUserDefaults.standardUserDefaults().objectForKey(USER_DEFAULTS.FAVORITES) as? NSData{
            let favorites = NSKeyedUnarchiver.unarchiveObjectWithData(decodedObject) as! [NSMapItem]
            
            items = favorites
        }
        return items
    }
    
    func deleteFavorites(){
        defaults.setObject(nil, forKey: USER_DEFAULTS.FAVORITES)
        defaults.synchronize()
    }
    
    
}