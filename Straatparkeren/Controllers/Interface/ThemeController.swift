//
//  ThemeController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 24/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit
import MapKit
import GPUImage
import AVFoundation

// implement protocol along with notification listeners
protocol ThemeProtocol{
    // Day mode should render dark text and controls on a light background
    func setDayMode()
    // Night mode should render light text and controls on a dark background
    func setNightMode()
}


// Day/night theme variables
public enum THEME : Int {
    case DAY, NIGHT
    
    func getColorForType(type : COLOR_TYPE) -> UIColor{
        switch type {
        case .TEXT:
            return self.TEXT
        case .BACKGROUND:
            return self.BACKGROUND
        case .BUTTON:
            return self.BUTTON
        case .SWITCH:
            return self.SWITCH
        case .HIGH_CONTRAST:
            return self.HIGH_CONTRAST
        }
    }
    
    var TEXT: UIColor {
        switch self {
        case .DAY:
            return C.DARK
        case .NIGHT:
            return C.LIGHT
        }
    }
    
    var BACKGROUND: UIColor {
        switch self {
        case .DAY:
            return C.LIGHT
        case .NIGHT:
            return C.DARK
        }
    }
    
    var SWITCH: UIColor {
        switch self {
        case .DAY:
            return C.DARK
        case .NIGHT:
            return C.LIGHT
        }
    }
    
    var BUTTON: UIColor {
        return C.BUTTON.DARK
    }
    
    var HIGH_CONTRAST: UIColor {
        return C.SEMI
    }
    
    var KEYBOARD : UIKeyboardAppearance{
        switch self {
        case .DAY:
            return .Light
        case .NIGHT:
            return .Dark
        }
    }
    
    var notificationKey : String{
        switch self {
        case .DAY:
            return N.DAY_MODE
        case .NIGHT:
            return N.NIGHT_MODE
        }
    }
}

class ThemeController: NSObject {
    
    // Singleton instance
    static let sharedInstance = ThemeController()
    
    var checkTimer : NSTimer?
    var brightnessStack : [CGFloat] = []
    
    func start(){
        self.checkBrightness()
        self.checkTimer = NSTimer.scheduledTimerWithTimeInterval(DD.BRIGHTNESS_INTERVAL, target: self, selector: #selector(self.checkBrightness), userInfo: nil, repeats: true)
    }
    
    // Check for light intensity
    // User must have auto-brightness turned
    internal func checkBrightness(){
        let theme = DefaultsController.sharedInstance.getCurrentTheme()
        var newTheme : THEME!
        
        let brightness = UIScreen.mainScreen().brightness
        brightnessStack.append(brightness)
        
        if brightnessStack.count > DD.BRIGHTNESS_STACK{
            brightnessStack = Array(brightnessStack[1..<DD.BRIGHTNESS_STACK])
            
            // Calculate average of gathered brightness values and check if it exceeds predefined value
            let average : CGFloat = brightnessStack.reduce(0, combine: +) / CGFloat(brightnessStack.count)
            
            if average > DD.BRIGHTNESS_TRIGGER{
                newTheme = .DAY
            }else{
                newTheme = .NIGHT
            }
            
            if theme != newTheme{
                self.setTheme(newTheme)
            }
            
        }
        
    }
    
    func stop(){
        self.checkTimer?.invalidate()
        self.checkTimer = nil
    }
    
    // Switch themes
    @objc private func toggleTheme(){
        if(DefaultsController.sharedInstance.getCurrentTheme() == .NIGHT){
            setTheme(.DAY)
        }else{
            setTheme(.NIGHT)
        }
    }
    
    func setTheme(theme: THEME) {
        DefaultsController.sharedInstance.setTheme(theme)
        
        //callout to all setDay / Night methods
        NSNotificationCenter.defaultCenter().postNotificationName(theme.notificationKey, object: self)
        
    }
    
    
}
