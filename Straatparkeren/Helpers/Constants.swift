//
//  Constants.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 09/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit


//STYLE RELATED
public struct S{
    public struct OPACITY{
        public static let LIGHT : CGFloat = 0.25
        public static let REGULAR : CGFloat = 0.5
        public static let DARK : CGFloat = 0.75
        public static let XDARK : CGFloat = 0.85
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

public struct USER_DEFAULTS{
    public static let FIRST_TIME = "FirstTimeUse"
    public static let CURRENT_THEME = "CurrentTheme"
    public static let CURRENT_MODE = "CurrentMode"
}

/* Notification keys */
public struct N{
    public static let DAY_MODE = "DayMode"
    public static let NIGHT_MODE = "NightMode"
    public static let MINIMAL_MODE = "MinimalMode"
    public static let MEDIUM_MODE = "MediumMode"
    public static let MAXIMAL_MODE = "MaximalMode"
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

/* KEYS */
public struct K{
    public static let GOOGLE_MAPS_API = "GoogleMapsAPIKey"
}

public struct STR{
    public static let navbar_search_btn = "Zoeken"
    public static let map_home_btn = "Huidige Locatie"
    public static let navbar_back_btn = "Terug"
    public static let search_no_results = "Geen resultaten"
    public static let explanation_text = "In deze app kunt u de parkeerbezetting zien van de gewenste locatie. Groen geeft de meeste kans op voldoende parkeerplaatsen. \n Deze app toont functionaliteit afhankelijk van uw veiligheid."
    public static let explanation_btn = "Begrepen"
}

