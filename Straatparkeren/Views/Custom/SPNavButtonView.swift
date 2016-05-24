//
//  SPNavButtonView.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 20/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SPNavButtonView: UIView {
    
    var btnIcon : UIImageView?
    var btnText : UILabel?

    init(frame : CGRect, image : UIImage, text : String) {
        super.init(frame: frame)
        
        btnIcon  = UIImageView(frame: CGRect(x: D.SPACING.REGULAR, y: D.SPACING.REGULAR, w: frame.width - (D.SPACING.REGULAR * 2), h: frame.height / 2))
        btnIcon?.image = image.imageWithRenderingMode(.AlwaysTemplate)
        btnIcon?.tintColor = ThemeController.sharedInstance.currentTheme().TEXT
        btnIcon?.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(btnIcon!)
        
        btnText = UILabel(x: D.SPACING.REGULAR, y: frame.height - D.SPACING.REGULAR - D.FONT.XXLARGE, w: frame.width - (D.SPACING.REGULAR * 2), h: 100, fontSize: D.FONT.XXLARGE)
        btnText!.text = text
        btnText?.fitHeight()
        btnText?.textColor = ThemeController.sharedInstance.currentTheme().TEXT
        btnText!.textAlignment = .Center
        self.addSubview(btnText!)
    }
    
    func resetColors(){
        btnIcon?.tintColor = ThemeController.sharedInstance.currentTheme().TEXT
        btnText?.textColor = ThemeController.sharedInstance.currentTheme().TEXT
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
