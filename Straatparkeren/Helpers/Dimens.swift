//
//  Dimens.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 09/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

public struct D{
    
    //DEFAULTS
    public static let SCREEN_WIDTH_ORIGINAL = UIScreen.mainScreen().bounds.width
    public static let SCREEN_WIDTH = D.SCREEN_WIDTH_ORIGINAL - D.CARPLAY.WIDTH
    public static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
    
    public struct SPACING{
        public static let SMALL : CGFloat = 8.0
        public static let REGULAR : CGFloat = 16.0
        public static let LARGE : CGFloat = 24.0
        public static let XLARGE : CGFloat = 32.0
        public static let XXLARGE : CGFloat = 40.0
    }
    
    
    public struct FONT{
        public static let SMALL : CGFloat = 12.0
        public static let REGULAR : CGFloat = 16.0
        public static let LARGE : CGFloat = 20.0
        public static let XLARGE : CGFloat = 24.0
        public static let XXLARGE : CGFloat = 28.0
    }
    
    //OTHER
    public struct CARPLAY{
        public static let WIDTH :CGFloat = 100.0
        public static let BTN_WIDTH :CGFloat = D.CARPLAY.WIDTH - (D.SPACING.REGULAR * 2)
        public static let BORDER_WIDTH :CGFloat = 1.0
    }
    
    public struct SPRINGBOARD{
        public static let ICON_MARGIN : CGFloat = 80.0
    }
    
    public struct NAVBAR{
        public static let HEIGHT : CGFloat = 188.0
        public static let HEIGHT_DEFAULT : CGFloat = 44.0
        public static let HEIGHT_DIFF : CGFloat = D.NAVBAR.HEIGHT - D.NAVBAR.HEIGHT_DEFAULT
    }
    
}
