//
//  SPTabbar.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 05-06-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SPTabbar: UIView {
    
    var settingsBtn     : SPNavButtonView!
    var favoritesBtn    : SPNavButtonView!
    var searchBtn       : SPNavButtonView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Add background
        let background : UIView = UIView(frame:
            CGRectMake(
                0,
                frame.height - D.NAVBAR.HEIGHT,
                frame.width,
                D.NAVBAR.HEIGHT
            ))
        background.backgroundColor = ThemeController.sharedInstance.currentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.DARK)
        self.addSubview(background)
        
        // Settings button
        settingsBtn = SPNavButtonView(frame: CGRectMake(
            frame.width - D.NAVBAR.BTN_WIDTH,
            0,
            D.NAVBAR.BTN_WIDTH,
            background.frame.height
            ), image: UIImage(named: "AppSettingsIcon")!, text: STR.settings_text)
        
        background.addSubview(settingsBtn)
        
        // Favorites button
        favoritesBtn = SPNavButtonView(frame: CGRectMake(
            (frame.width - D.NAVBAR.BTN_WIDTH) / 2,
            0,
            D.NAVBAR.BTN_WIDTH,
            background.frame.height
            ), image: UIImage(named: "FavoriteIcon")!, text: STR.favorites_text)
        
        background.addSubview(favoritesBtn)
        
        // Search button
        searchBtn = SPNavButtonView(frame: CGRectMake(
            0,
            0,
            D.NAVBAR.BTN_WIDTH,
            background.frame.height
            ), image: UIImage(named: "SearchIcon")!, text: STR.navbar_search_btn)
        
        background.addSubview(searchBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
