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
    
    func addFavorite(favorite : NSMapItem){
        var favorites = getFavorites()
        
        favorites = (favorites.count >= DefaultsController.maxFavorites) ? Array(favorites[1..<DefaultsController.maxFavorites]) : favorites
        
        favorites.append(favorite)
        
        let encodedObject : NSData = NSKeyedArchiver.archivedDataWithRootObject(favorites as NSArray)
        
        defaults.setObject(encodedObject, forKey: USER_DEFAULTS.FAVORITES)
        
        for favorite in getFavorites(){
            print(favorite.title)
        }
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
    }
    
    
}