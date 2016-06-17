//
//  Helpers.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 09/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit
import AVFoundation

// Convert RGB values to UIColor
func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor {
    let scanner = NSScanner(string:colorCode)
    var color:UInt32 = 0;
    scanner.scanHexInt(&color)
    
    let mask = 0x000000FF
    let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
    let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
    let b = CGFloat(Float(Int(color) & mask)/255.0)
    
    return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
}

// return key for string used in Keys.plist
func getKeyFor(id : String) -> String{
    var keys: NSDictionary?
    var returnKey = ""
    
    if let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist") {
        keys = NSDictionary(contentsOfFile: path)
    }
    
    if let dict = keys {
        returnKey = (dict[id] as? String)!
    }
    
    return returnKey
}

// Remove all gestures from view to prevent missing gestures
func removeGestureRecognizers(view : UIView){
    if let recognizers = view.gestureRecognizers{
        for recognizer in recognizers{
            view.removeGestureRecognizer(recognizer)
        }
    }
}

// Play system sound for notifications
// TODO: make generic to receive sound id
func playNotificationSound(){
    AudioServicesPlaySystemSound(SOUND.APP)
}



