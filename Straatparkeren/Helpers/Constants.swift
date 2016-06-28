//
//  Constants.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 09/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation


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

/* DEBUG/DEMO VALUES */
public struct DD{
    public static let NPA = 0
    public static let BRIGHTNESS_TRIGGER : CGFloat = 0.75
    public static let BRIGHTNESS_INTERVAL = 2.0
    public static let BRIGHTNESS_STACK = 2 //minimum 2
    public static let BRIGHTNESS_ON = false
}

// User defaults keys
public struct USER_DEFAULTS{
    public static let FIRST_TIME = "FirstTimeUse"
    public static let CURRENT_THEME = "CurrentTheme"
    public static let CURRENT_MODE = "CurrentMode"
    public static let SAFETY_MODE = "SafetyMode"
    public static let AUTOMATIC_SHUTDOWN = "AutomaticShutdown"
    public static let LOCATION_NOTIFICATION = "LocationNotification"
    public static let ETA_NOTIFICATION = "ETANotification"
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
    public static let navbar_search_btn = NSLocalizedString("Zoeken", comment: "")
    public static let map_home_btn = NSLocalizedString("Huidige Locatie", comment: "")
    public static let navbar_back_btn = NSLocalizedString("Terug", comment: "")
    public static let search_no_results = NSLocalizedString("Geen resultaten", comment: "")
    public static let explanation_text = NSLocalizedString("In deze app kunt u de parkeerbezetting zien van de gewenste locatie. Groen geeft de meeste kans op voldoende parkeerplaatsen. Oranje is geeft minder garantie op voldoende plaatsen.", comment: "")
    public static let explanation_btn = NSLocalizedString("Gereed", comment: "")
    public static let disclaimer_text = NSLocalizedString("Het gebruik van deze applicatie is niet toegestaan tijdens het rijden.  Ieder gebruik van de applicatie is geheel op eigen risico. De makers kunnen niet aansprakelijk worden gesteld.", comment: "")
    public static let disclaimer_btn = NSLocalizedString("Akkoord", comment: "")
    public static let info_btn = NSLocalizedString("Info", comment: "")
    public static let settings_text = NSLocalizedString("Instellingen", comment: "")
    public static let favorites_text = NSLocalizedString("Favorieten", comment: "")
    public static let confirm_btn = NSLocalizedString("Bevestig bestemming", comment: "")
    public static let confirm_btn_success = NSLocalizedString("Bevestigd!", comment: "")
    
    //settings
    public static let settings_safety_title = NSLocalizedString("Extra veilige modus", comment: "")
    public static let settings_safety_subtitle = NSLocalizedString("In de extra veilige modus bepaalt de app wanneer functionaliteiten van de app wel of niet veilig zijn om te gebruiken.", comment: "")
    public static let settings_shutdown_title = NSLocalizedString("Automatisch afsluiten", comment: "")
    public static let settings_shutdown_subtitle = NSLocalizedString("De app sluit automatisch af gedurende langere tijd van inactiviteit.", comment: "")
    public static let settings_favorites_title = NSLocalizedString("Favorieten wissen", comment: "")
    public static let settings_location_title = NSLocalizedString("Open app op:", comment: "")
    public static let settings_location_subtitle = NSLocalizedString("Toon automatisch de Straatparkeren app op de gekozen afstanden tot de bestemming.", comment: "")
    public static let settings_location_segmented_label = NSLocalizedString("KM afstand", comment: "")
    public static let settings_eta_title = NSLocalizedString("Reistijd melding:", comment: "")
    public static let settings_eta_subtitle = NSLocalizedString("Toon melding wanneer de reistijd minder dan het geselecteerd aantal minuten is.", comment: "")
    public static let settings_eta_segmented_label = NSLocalizedString("minuten", comment: "")
    public static let settings_destination_title = NSLocalizedString("Toon meldingen", comment: "")
    public static let settings_destination_subtitle = NSLocalizedString("Toon meldingen als er onverwacht veranderingen zijn in de parkeerbezetting rondom uw bestemming.", comment: "")
    
    
    public static let navbar_favorite_btn = NSLocalizedString("Voeg toe", comment: "")
    public static let navbar_favorited_btn = NSLocalizedString("Toegevoegd!", comment: "")
    
    public static let home_btn_destination = NSLocalizedString("Bestemming", comment: "")
    public static let home_btn_location = NSLocalizedString("Huidige locatie", comment: "")
    
    //notifications
    public static let notification_default = NSLocalizedString("Op uw bestemming zijn nu voldoende vrije plaatsen.", comment: "")
    public static let notification_eta = NSLocalizedString("U bereikt uw bestemming over %d ", comment: "")
    public static let notification_eta_minutes = NSLocalizedString("minuten.", comment: "")
    public static let notification_eta_minute = NSLocalizedString("minuut.", comment: "")
}

// Animation related
public struct ANI{
    public static let NOTIFICATION_DISMISS = 5.0
    
    public struct DUR{
        public static let GRADUALLY = 3.0
        public static let SLOW = 1.5
        public static let REGULAR = 0.5
        public static let FAST = 0.3
    }
}

// Sounds
public struct SOUND{
    public static let APP : SystemSoundID = 1022
}

