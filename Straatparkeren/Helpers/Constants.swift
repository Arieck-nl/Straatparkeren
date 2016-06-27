//
//  Constants.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 09/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit
import AVFoundation


// Style related
public struct S{
    public struct OPACITY{
        public static let XLIGHT : CGFloat = 0.1
        public static let LIGHT : CGFloat = 0.25
        public static let REGULAR : CGFloat = 0.5
        public static let DARK : CGFloat = 0.75
        public static let XDARK : CGFloat = 0.85
        public static let XXDARK : CGFloat = 0.95
    }
}

// Parking availability related
public enum PARKING_STATE : Int {
    case FREE
    case SEMI_FULL
    
    var color: UIColor {
        switch self {
        case .FREE: return C.PARKING_STATE.FREE
        case .SEMI_FULL: return C.PARKING_STATE.SEMI_FULL
        }
    }
    
}

// User defaults keys
public struct USER_DEFAULTS{
    public static let FIRST_TIME = "FirstTimeUse"
    public static let CURRENT_THEME = "CurrentTheme"
    public static let CURRENT_MODE = "CurrentMode"
    public static let SAFETY_MODE = "SafetyMode"
    public static let AUTOMATIC_SHUTDOWN = "AutomaticShutdown"
    public static let LOCATION_NOTIFICATION = "LocationNotification"
    public static let DESTINATION_NOTIFICATION = "DestinationNotification"
    public static let CURRENT_DESTINATION = "CurrentDestination"
    public static let FAVORITES = "Favorites"
}

// NSNotification keys
public struct N{
    public static let DAY_MODE = "DayMode"
    public static let NIGHT_MODE = "NightMode"
    public static let MINIMAL_MODE = "MinimalMode"
    public static let MEDIUM_MODE = "MediumMode"
    public static let MAXIMAL_MODE = "MaximalMode"
    public static let LOCATION_TRIGGER = "LocationTrigger"
    public static let DESTINATION_TRIGGER = "DestinationTrigger"
}


// API URLs
public struct API{
    /* 
     PARAMETERS:
        path        : path
        key         : api key
        interpolate : interpolate (optional)
     */
    public static let GOOGLE_MAPS_ROADS = "https://roads.googleapis.com/v1/snapToRoads"
    
    public static let HERE_TRAFFIC = "https://traffic.cit.api.here.com/traffic/6.1/flow.json"
}

// API key and app id's
public struct K{
    public static let GOOGLE_MAPS_API = "GoogleMapsAPIKey"
    public static let HERE_APP_CODE = "HereAppCode"
    public static let HERE_APP_ID = "HereAppID"
}


// Strings 
// TODO: make this into string file
public struct STR{
    public static let navbar_search_btn = "Zoeken"
    public static let map_home_btn = "Huidige Locatie"
    public static let navbar_back_btn = "Terug"
    public static let search_no_results = "Geen resultaten"
    public static let explanation_text = "In deze app kunt u de parkeerbezetting zien van de gewenste locatie. Groen geeft de meeste kans op voldoende parkeerplaatsen."
    public static let explanation_btn = "Gereed"
    public static let disclaimer_text = "Het gebruik van deze applicatie is niet toegestaan tijdens het rijden.  Ieder gebruik van de applicatie is geheel op eigen risico. De makers kunnen niet aansprakelijk worden gesteld."
    public static let disclaimer_btn = "Akkoord"
    public static let info_btn = "Info"
    public static let settings_text = "Instellingen"
    public static let favorites_text = "Favorieten"
    public static let confirm_btn = "Bevestig bestemming"
    public static let confirm_btn_success = "Bevestigd!"
    
    //settings
    public static let settings_safety_title = "Extra veilige modus"
    public static let settings_safety_subtitle = "In de extra veilige modus bepaalt de app wanneer functionaliteiten van de app wel of niet veilig zijn om te gebruiken."
    public static let settings_shutdown_title = "Automatisch afsluiten"
    public static let settings_shutdown_subtitle = "De app sluit automatisch af gedurende langere tijd van inactiviteit."
    public static let settings_favorites_title = "Favorieten wissen"
    public static let settings_location_title = "Toon parkeerbezetting op:"
    public static let settings_location_subtitle = "Toon automatisch de parkeerbezetting op de gekozen afstanden tot de bestemming."
    public static let settings_location_segmented_label = "KM afstand"
    public static let settings_destination_title = "Toon meldingen"
    public static let settings_destination_subtitle = "Toon meldingen als er onverwacht veranderingen zijn in de parkeerbezetting rondom uw bestemming."
    
    
    public static let navbar_favorite_btn = "Voeg toe"
    public static let navbar_favorited_btn = "Toegevoegd!"
    
    public static let home_btn_destination = "Bestemming"
    public static let home_btn_location = "Huidige locatie"
    
    //notifications
    public static let notification_default = "Op uw bestemming zijn nu voldoende vrije plaatsen."
}

// Animation related
public struct ANI{
    public static let NOTIFICATION_DISMISS = 5.0
    
    public struct DUR{
        public static let GRADUALLY = 3.0
        public static let REGULAR = 0.5
        public static let FAST = 0.3
    }
}

// Sounds
public struct SOUND{
    public static let APP : SystemSoundID = 1022
}

