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
    public static let SAFETY_MODE = "SafetyMode"
    public static let AUTOMATIC_SHUTDOWN = "AutomaticShutdown"
    public static let LOCATION_NOTIFICATION = "LocationNotification"
    public static let DESTINATION_NOTIFICATION = "DestinationNotification"
    public static let CURRENT_DESTINATION = "CurrentDestination"
    public static let FAVORITES = "Favorites"
}

/* Notification keys */
public struct N{
    public static let DAY_MODE = "DayMode"
    public static let NIGHT_MODE = "NightMode"
    public static let MINIMAL_MODE = "MinimalMode"
    public static let MEDIUM_MODE = "MediumMode"
    public static let MAXIMAL_MODE = "MaximalMode"
    public static let LOCATION_TRIGGER = "LocationTrigger"
}

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

/* KEYS */
public struct K{
    public static let GOOGLE_MAPS_API = "GoogleMapsAPIKey"
    public static let HERE_APP_CODE = "HereAppCode"
    public static let HERE_APP_ID = "HereAppID"
}

public struct STR{
    public static let navbar_search_btn = "Zoeken"
    public static let map_home_btn = "Huidige Locatie"
    public static let navbar_back_btn = "Terug"
    public static let search_no_results = "Geen resultaten"
    public static let explanation_text = "In deze app kunt u de parkeerbezetting zien van de gewenste locatie. Groen geeft de meeste kans op voldoende parkeerplaatsen. \n Deze app toont functionaliteit afhankelijk van uw veiligheid."
    public static let explanation_btn = "Begrepen"
    public static let settings_text = "Instellingen"
    public static let favorites_text = "Favorieten"
    
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
    
    
}

