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
        searchIconView.frame = CGRect(x: 0, y: 0, w: D.SEARCHBAR.ICON_HEIGHT, h: D.SEARCHBAR.ICON_HEIGHT)
        searchIconView.tintColor = C.TEXT
        
//        let clearIconView = searchField.valueForKey("clearButton") as! UIButton
//        clearIconView.setImage(UIImage(named: "clearIcon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
//        clearIconView.setImage(UIImage(named: "clearIcon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Selected)
//        clearIconView.setImage(UIImage(named: "clearIcon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Focused)
//        clearIconView.frame = CGRect(x: -20.0, y: -20.0, w: D.SEARCHBAR.ICON_HEIGHT, h: D.SEARCHBAR.ICON_HEIGHT)
//        clearIconView.imageView?.size = CGSize(width: D.SEARCHBAR.ICON_HEIGHT, height: D.SEARCHBAR.ICON_HEIGHT)
//        clearIconView.tintColor = C.TEXT
        
        searchField.frame = CGRectMake(5.0, 5.0, frame.size.width - 10.0, frame.size.height - 10.0)
        searchField.clearButtonMode = .Never
        searchField.tintColor = C.TEXT
        searchField.textColor = C.TEXT
        searchField.font = searchField.font!.fontWithSize(D.FONT.XXXLARGE)
        
        searchField.backgroundColor = C.BACKGROUND.colorWithAlphaComponent(S.OPACITY.REGULAR)
        
        self.tintColor = C.BACKGROUND.colorWithAlphaComponent(S.OPACITY.DARK)
        
        super.drawRect(rect)
    }
    
    
    
}
