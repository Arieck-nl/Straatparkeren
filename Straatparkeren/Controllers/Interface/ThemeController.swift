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
    
    var videoCamera : AverageLuminanceExtractor!
    
    var camera : Camera!
    
    func start(){
        //        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(self.toggleTheme), userInfo: nil, repeats: true)
        
        /*/// TODO: Remove this and change toggle theme to set theme
         renderView = RenderView(superView: self.view)
         self.view.addSubview(renderView)
         let filter = AverageLuminanceExtractor()
         filter.extractedLuminanceCallback = {luminance in
         print(luminance)
         }
         
         do {
         camera = try Camera(sessionPreset: AVCaptureSessionPreset640x480, location: .FrontFacing)
         camera --> filter --> renderView
         
         while (true) {
         camera.startCapture()
         
         
         }
         } catch {
         fatalError("Could not initialize rendering pipeline: \(error)")
         }
         /// */
        
        
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
