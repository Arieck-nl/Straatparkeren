//
//  Colors.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 11/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import Foundation

import UIKit

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

    public static let BACKGROUND = UIColorFromRGB("000000")
    public static let TEXT = UIColorFromRGB("FFFFFF")
    
}