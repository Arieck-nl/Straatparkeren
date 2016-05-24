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
        
        // Text field in search bar.
        let searchField = self.valueForKey("searchField") as! UITextField
        
        let searchIconView = searchField.leftView as! UIImageView
        searchIconView.image = UIImage(named:"SearchIcon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        searchIconView.frame = CGRect(x: searchIconView.frame.x, y: searchIconView.frame.y, w: D.SEARCHBAR.ICON_HEIGHT, h: D.SEARCHBAR.ICON_HEIGHT)
        searchIconView.tintColor = ThemeController.sharedInstance.currentTheme().TEXT
        
//        let clearIconView = searchField.valueForKey("clearButton") as! UIButton
//        clearIconView.setImage(UIImage(named: "ClearIcon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
//        clearIconView.setImage(UIImage(named: "ClearIcon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Selected)
//        clearIconView.setImage(UIImage(named: "ClearIcon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Focused)
//        clearIconView.frame = CGRect(x: -20.0, y: -20.0, w: D.SEARCHBAR.ICON_HEIGHT, h: D.SEARCHBAR.ICON_HEIGHT)
//        clearIconView.imageView?.size = CGSize(width: D.SEARCHBAR.ICON_HEIGHT, height: D.SEARCHBAR.ICON_HEIGHT)
//        clearIconView.tintColor = C.TEXT
        
        searchField.frame = CGRectMake(D.SPACING.SMALL, D.SPACING.SMALL, frame.size.width - (D.SPACING.SMALL * 2), frame.size.height - (D.SPACING.SMALL * 2))
        searchField.clearButtonMode = .Never
        searchField.tintColor = ThemeController.sharedInstance.currentTheme().TEXT
        searchField.textColor = ThemeController.sharedInstance.currentTheme().TEXT
        searchField.font = searchField.font!.fontWithSize(D.FONT.XXXLARGE)
        
        searchField.backgroundColor = ThemeController.sharedInstance.currentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.REGULAR)
        
        self.tintColor = ThemeController.sharedInstance.currentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.DARK)
        
        self.keyboardAppearance = .Dark
        
        super.drawRect(rect)
    }
    
    
    
}
