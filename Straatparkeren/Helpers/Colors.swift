//
//  Colors.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 11/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import Foundation

import UIKit


// Color constants
public struct C{
    
    //DEFAULTS
    public struct PRIMARY{
        public static let LIGHT = UIColorFromRGB("20BE60")
        public static let REGULAR = UIColorFromRGB("00B047")
        public static let DARK = UIColorFromRGB("008C38")
    }
    
    public struct SECONDARY1{
        public static let LIGHT = UIColorFromRGB("EF7C45")
        public static let REGULAR = UIColorFromRGB("E25816")
        public static let DARK = UIColorFromRGB("B24009")
    }
    
    public struct SECONDARY2{
        public static let LIGHT = UIColorFromRGB("E53F3F")
        public static let REGULAR = UIColorFromRGB("CC1919")
        public static let DARK = UIColorFromRGB("A60808")
    }
    
    public static let LIGHT = UIColorFromRGB("FFFFFF")
    public static let DARK = UIColorFromRGB("000000")
    
    public struct BUTTON{
        public static let LIGHT = UIColorFromRGB("75C8F7")
        public static let DARK = UIColorFromRGB("2A9DE1")
    }
    
    
    public static var BACKGROUND = C.DARK
    public static var TEXT = C.LIGHT
    
    //OTHER
    
    // Parking State colors
    public struct PARKING_STATE{
        public static let FREE = UIColor.greenColor().colorWithAlphaComponent(S.OPACITY.REGULAR)
        public static let SEMI_FULL = UIColor.orangeColor().colorWithAlphaComponent(S.OPACITY.REGULAR)
        public static let FULL = UIColor.redColor().colorWithAlphaComponent(S.OPACITY.REGULAR)
    }
    
    public static var FAVORITED = UIColor.yellowColor()
    public static var MARKER = UIColor.redColor()
    
}
