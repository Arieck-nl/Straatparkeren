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
    
    /** ------- First time use --------*/
    // Return bool for first time use default
    func isFirstTimeUse() -> Bool{
        return defaults.boolForKey(USER_DEFAULTS.FIRST_TIME)
    }
    
    // Set bool for first time use default
    func setFirstTimeUse(value : Bool){
        defaults.setBool(value, forKey: USER_DEFAULTS.FIRST_TIME)
        defaults.synchronize()
        
    }
    /** ------- safety mode --------*/
    // Return if user has high safety mode on
    func isInSafetyMode() -> Bool{
        let safetyMode = defaults.boolForKey(USER_DEFAULTS.SAFETY_MODE)
        return safetyMode
    }
    
    func toggleSafetyMode(){
        let safetyMode = isInSafetyMode()
        defaults.setBool(!safetyMode, forKey: USER_DEFAULTS.SAFETY_MODE)
        defaults.synchronize()
    }
    /** ------- Automatic shutdown --------*/
    // Return if user has automatic shutdown turned on
    func isAutomaticShutdownOn() -> Bool{
        let shutdown = defaults.boolForKey(USER_DEFAULTS.AUTOMATIC_SHUTDOWN)
        return shutdown
    }
    
    func toggleAutomaticShutdown(){
        let shutdown = isAutomaticShutdownOn()
        defaults.setBool(!shutdown, forKey: USER_DEFAULTS.AUTOMATIC_SHUTDOWN)
        defaults.synchronize()
    }
    
    /** ------- Location/destination notifications --------*/
    // Return if user has destination based notifications turned on
    func isDestinationNotificationsOn() -> Bool{
        let isOn = defaults.boolForKey(USER_DEFAULTS.DESTINATION_NOTIFICATION)
        return isOn
    }
    
    func toggleDestinationNotification(){
        let isOn = isDestinationNotificationsOn()
        defaults.setBool(!isOn, forKey: USER_DEFAULTS.DESTINATION_NOTIFICATION)
        defaults.synchronize()
    }
    
    // Return set distances for location notification distances
    func getLocationNotificationDistances() -> [Double]{
        var items : [Double] = []
        if let decodedObject : NSData = NSUserDefaults.standardUserDefaults().objectForKey(USER_DEFAULTS.LOCATION_NOTIFICATION) as? NSData{
            let distances = NSKeyedUnarchiver.unarchiveObjectWithData(decodedObject) as! [Double]
            
            items = distances
        }
        return items
    }
    
    // Set distances for location to destination notifications
    // Pass settings to LocationDependantController as to begin monitoring
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
    }
    
    /** ------- Destination --------*/
    // Set current chosen destination, also update location notification location
    func setDestination(destination : NSMapItem){
        let encodedObject : NSData = NSKeyedArchiver.archivedDataWithRootObject(destination)
        
        defaults.setObject(encodedObject, forKey: USER_DEFAULTS.CURRENT_DESTINATION)
        defaults.synchronize()
        
        self.setLocationNotificationDistances(self.getLocationNotificationDistances())
        // TODO: implement ETA dependant monitoring?
    }
    
    // Get current set destination
    func getDestination() -> NSMapItem?{
        var destination : NSMapItem?
        if let decodedObject : NSData = NSUserDefaults.standardUserDefaults().objectForKey(USER_DEFAULTS.CURRENT_DESTINATION) as? NSData{
            destination = NSKeyedUnarchiver.unarchiveObjectWithData(decodedObject) as? NSMapItem
            
        }
        return destination
    }
    
    
    /** ------- Favorites --------*/
    // Add favorites
    // - parameter favorite: feed favorite as NSMapItem
    func addFavorite(favorite : NSMapItem){
        var favorites = getFavorites()
        
        // limit favorites to maxFavorites, first in first out
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
    
    /** ------- Theme --------*/
    func getCurrentTheme() -> THEME {
        if let themeID = defaults.valueForKey(USER_DEFAULTS.CURRENT_THEME)?.integerValue {
            return  THEME(rawValue: themeID)!
        } else {
            return .NIGHT
        }
    }
    
    func setTheme(theme: THEME) {
        defaults.setValue(theme.rawValue, forKey: USER_DEFAULTS.CURRENT_THEME)
        defaults.synchronize()
    }
    
    /** ------- Interface mode --------*/
    func getInterfaceMode() -> I_MODE {
        if let modeID = defaults.valueForKey(USER_DEFAULTS.CURRENT_MODE)?.integerValue {
            return  I_MODE(rawValue: modeID)!
        } else {
            // fall back to most safe a.k.a. minimal mode
            return .MINIMAL
        }
    }
    
    func setInterfaceMode(mode: I_MODE) {
        if(self.getInterfaceMode() != mode){
            
            defaults.setValue(mode.rawValue, forKey: USER_DEFAULTS.CURRENT_MODE)
            defaults.synchronize()
        }
    }
    
    
}