//
//  Constants.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 09/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

//TODO: remove unused stuff

// FONTS
let FONT_REGULAR = "AzoSans-Regular"

//STYLE RELATED
public struct S{
    public struct OPACITY{
        public static let REGULAR : CGFloat = 0.5
        public static let DARK : CGFloat = 0.75
    }
    
    
}

public enum PARKING_STATE : Int {
    case FREE
    case SEMI_FULL
    case FULL
    
    var color: UIColor {
        switch self {
        case .FREE: return C.PARKING_STATE.FREE
        case .SEMI_FULL: return C.PARKING_STATE.SEMI_FULL
        case .FULL: return C.PARKING_STATE.FULL
        }
    }
    
    
    
}

public struct API{
    public static let GOOGLE_MAPS_ROADS = "https://roads.googleapis.com/v1/snapToRoads"
    /* 
     PARAMETERS:
        path        : path
        key         : api key
        interpolate : interpolate (optional)
     */
}

public struct K{
    public static let GOOGLE_MAPS_API = "GoogleMapsAPIKey"
}

public struct STR{
    public static let navbar_search_btn = "Zoeken"
    public static let navbar_back_btn = "Terug"
}

