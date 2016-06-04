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

protocol ThemeProtocol{
    // Day mode should render dark text and controls on a light background
    func setDayMode()
    // Night mode should render light text and controls on a dark background
    func setNightMode()
}

public enum THEME : Int {
    case DAY, NIGHT
    
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
        
        /*/// TODO: Remove this
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
