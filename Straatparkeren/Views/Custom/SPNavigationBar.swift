//
//  SPNavigationBar.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 11/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SPNavigationBar: UIView {
    
    private var titleLabel : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ThemeController.sharedInstance.currentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.DARK)
        titleLabel = UILabel(x: D.SPACING.REGULAR, y: (frame.height - D.FONT.XXXLARGE) / 2, w: self.frame.width - D.NAVBAR.HEIGHT - (D.SPACING.SMALL * 2), h: 100, fontSize: D.FONT.XXXLARGE)
        titleLabel?.textColor = ThemeController.sharedInstance.currentTheme().TEXT
        titleLabel?.fitHeight()
        self.addSubview(titleLabel!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTab(title: String, icon: String){
        
    }
    
    func setTitle(title : String){
        self.titleLabel!.text = title
        self.titleLabel!.fitHeight()
    }
    
    func resetColors(){
        self.backgroundColor = ThemeController.sharedInstance.currentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.DARK)
        titleLabel?.textColor = ThemeController.sharedInstance.currentTheme().TEXT

    }
    
}
