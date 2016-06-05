//
//  DefaultsController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 05-06-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import Foundation

class DefaultsController : NSObject{
    
    // Singleton instance
    static let sharedInstance = DefaultsController()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    func isInSafetyMode() -> Bool{
        let safetyMode = NSUserDefaults.standardUserDefaults().boolForKey(USER_DEFAULTS.SAFETY_MODE)
        return safetyMode
    }
    
    func toggleSafetyMode(){
        let safetyMode = isInSafetyMode()
        NSUserDefaults.standardUserDefaults().setBool(!safetyMode, forKey: USER_DEFAULTS.SAFETY_MODE)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func isAutomaticShutdownOn() -> Bool{
        let shutdown = NSUserDefaults.standardUserDefaults().boolForKey(USER_DEFAULTS.AUTOMATIC_SHUTDOWN)
        return shutdown
    }
    
    func toggleAutomaticShutdown(){
        let shutdown = isAutomaticShutdownOn()
        NSUserDefaults.standardUserDefaults().setBool(!shutdown, forKey: USER_DEFAULTS.AUTOMATIC_SHUTDOWN)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
}