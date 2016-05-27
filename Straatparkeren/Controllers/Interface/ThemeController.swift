//
//  ThemeController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 24/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit
import MapKit

protocol ThemeDelegate{
    // Day mode should render dark text and controls on a light background
    func setDayMode()
    // Night mode should render light text and controls on a dark background
    func setNightMode()
}

class ThemeController: NSObject {
    
    // Singleton instance
    static let sharedInstance = ThemeController()
    
    func start(){
//        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(self.toggleTheme), userInfo: nil, repeats: true)
    }
    
    @objc private func toggleTheme(){
        if(self.currentTheme() == .NIGHT){
            setTheme(.DAY)
        }else{
            setTheme(.NIGHT)
        }
    }
    
    func currentTheme() -> THEME {
        if let themeID = NSUserDefaults.standardUserDefaults().valueForKey(USER_DEFAULTS.CURRENT_THEME)?.integerValue {
            return  THEME(rawValue: themeID)!
        } else {
            return .NIGHT
        }
    }
    
    func setTheme(theme: THEME) {
        NSUserDefaults.standardUserDefaults().setValue(theme.rawValue, forKey: USER_DEFAULTS.CURRENT_THEME)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        //callout to all setDay / Night methods
        print(theme.notificationKey)
        NSNotificationCenter.defaultCenter().postNotificationName(theme.notificationKey, object: self)
        
    }
    
    
}
