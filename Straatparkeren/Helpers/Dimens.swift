//
//  Dimens.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 09/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit


// Dimension Constants
public struct D{
    
    //DEFAULTS
    public static let SCREEN_WIDTH_ORIGINAL = UIScreen.mainScreen().bounds.width
    public static let SCREEN_WIDTH = D.SCREEN_WIDTH_ORIGINAL - D.CARPLAY.WIDTH
    public static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
    
    public static let DIVIDER                   : CGFloat = 1.0
    public struct BTN{
        public struct HEIGHT{
            public static let REGULAR           : CGFloat = 64.0
            public static let LARGE             : CGFloat = 80.0
            public static let XLARGE            : CGFloat = 96.0
        }
    }
    
    public struct ICON{
        public struct HEIGHT{
            public static let REGULAR           : CGFloat = 64.0
            public static let LARGE             : CGFloat = 80.0
        }
    }
    
    public struct RADIUS{
            public static let REGULAR           : CGFloat = 16.0
    }
    
    public struct SPACING{
        public static let SMALL                 : CGFloat = 8.0
        public static let REGULAR               : CGFloat = 16.0
        public static let LARGE                 : CGFloat = 24.0
        public static let XLARGE                : CGFloat = 32.0
        public static let XXLARGE               : CGFloat = 40.0
        public static let XXXLARGE              : CGFloat = 48.0
    }
    
    
    public struct FONT{
        public static let SMALL                 : CGFloat = 12.0
        public static let REGULAR               : CGFloat = 16.0
        public static let LARGE                 : CGFloat = 20.0
        public static let XLARGE                : CGFloat = 24.0
        public static let XXLARGE               : CGFloat = 28.0
        public static let XXXLARGE              : CGFloat = 32.0
    }
    
    //OTHER
    public struct CARPLAY{
        public static let WIDTH                 : CGFloat = 100.0
        public static let BTN_WIDTH             : CGFloat = D.CARPLAY.WIDTH - (D.SPACING.REGULAR * 2)
        public static let BORDER_WIDTH          : CGFloat = 1.0
    }
    
    public struct MAP{
        public static let USER_MARKER_WIDTH     : CGFloat = 44.0
    }
    
    public struct SPRINGBOARD{
        public static let ICON_MARGIN           : CGFloat = 80.0
    }
    
    public struct NAVBAR{
        public static let HEIGHT                : CGFloat = 120.0
        public static let BTN_WIDTH             : CGFloat = D.NAVBAR.HEIGHT * 1.75
    }
    
    public struct SEARCHBAR{
        public static let ICON_HEIGHT           : CGFloat = 44.0
    }
    
    public struct SEARCH_CELL{
        public static let HEIGHT                : CGFloat = 88.0
    }

    public struct SETTINGS{
        public static let ROW_HEIGHT            : CGFloat = 160.0
        public static let SWITCH_HEIGHT         : CGFloat = 80.0
        public static let SEGMENTED_HEIGHT      : CGFloat = 80.0
        public static let SCROLL_OFFSET         : CGFloat = 80.0
    }
    
    // Parking availability
    public struct PA{
        public static let THICKNESS             : CGFloat = 10.0
    }
}
