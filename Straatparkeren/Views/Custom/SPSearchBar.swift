//
//  SPSearchBar.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 18/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SPSearchBar: UISearchBar {
    
    
    override func drawRect(rect: CGRect) {
        
        // Find text field in search bar
        let searchField = self.valueForKey("searchField") as! UITextField
        
        let searchIconView = searchField.leftView as! UIImageView
        searchIconView.image = UIImage(named:"SearchIcon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        searchIconView.frame = CGRect(x: searchIconView.frame.x, y: searchIconView.frame.y, w: D.SEARCHBAR.ICON_HEIGHT, h: D.SEARCHBAR.ICON_HEIGHT)
        searchIconView.tintColor = DefaultsController.sharedInstance.getCurrentTheme().TEXT
        
        searchField.frame = CGRectMake(D.SPACING.SMALL, D.SPACING.SMALL, frame.size.width - (D.SPACING.SMALL * 2), frame.size.height - (D.SPACING.SMALL * 2))
        searchField.clearButtonMode = .Never
        searchField.tintColor = DefaultsController.sharedInstance.getCurrentTheme().TEXT
        searchField.textColor = DefaultsController.sharedInstance.getCurrentTheme().TEXT
        searchField.font = searchField.font!.fontWithSize(D.FONT.XXXLARGE)
        
        searchField.backgroundColor = DefaultsController.sharedInstance.getCurrentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.REGULAR)
        
        self.tintColor = DefaultsController.sharedInstance.getCurrentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.DARK)
        
        self.keyboardAppearance = DefaultsController.sharedInstance.getCurrentTheme().KEYBOARD
        
        super.drawRect(rect)
    }
    
    
    
}
