//
//  SPOverlayView.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 20/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SPOverlayView: UIView {

    
    let dismissBtn      : UIButton = UIButton()
    let textLabel       : UILabel = UILabel()
    let iconView        : UIImageView = UIImageView()

    init(frame: CGRect, text : String, btnText : String, iconImg : UIImage = UIImage(named: "InfoIcon")!) {
        super.init(frame: frame)
        
        self.colorType = .BACKGROUND
        self.opacity = S.OPACITY.XDARK
        
        self.dismissBtn.setTitle(btnText, forState: .Normal)
        self.dismissBtn.titleLabel!.font = self.dismissBtn.titleLabel!.font.fontWithSize(D.FONT.XXXLARGE)
        self.dismissBtn.titleLabel?.textAlignment =  .Center
        self.dismissBtn.frame = CGRect(
            x: self.frame.width - D.NAVBAR.BTN_WIDTH,
            y: 0,
            w: D.NAVBAR.BTN_WIDTH,
            h: D.NAVBAR.HEIGHT
        )
        
        self.dismissBtn.setTitleColor(DefaultsController.sharedInstance.getCurrentTheme().BUTTON, forState: .Normal)
        self.dismissBtn.addTapGesture { (gesture) -> () in
            self.hide({ (Bool) in
                self.removeFromSuperview()
            })
        }
        self.addSubview(dismissBtn)
        
        self.iconView.frame = CGRect(
            x: (self.frame.width - D.ICON.HEIGHT.LARGE) / 2,
            y: self.dismissBtn.frame.y + D.SPACING.XXXLARGE + self.dismissBtn.frame.height,
            w: D.ICON.HEIGHT.LARGE,
            h: D.ICON.HEIGHT.LARGE)
        self.iconView.image = iconImg.imageWithRenderingMode(.AlwaysTemplate)
        self.iconView.colorType = .TEXT
        self.addSubview(self.iconView)
        
        
        self.textLabel.frame = CGRect(
            x: D.SPACING.XXXLARGE,
            y: D.SPACING.XXXLARGE + self.iconView.frame.y + self.iconView.frame.height,
            w: self.frame.width - (D.SPACING.XXXLARGE * 2),
            h: self.frame.height - self.iconView.frame.height - self.iconView.frame.y - (D.SPACING.XXLARGE * 3))
        
        self.textLabel.text = text
        self.textLabel.font = self.textLabel.font.fontWithSize(D.FONT.XXLARGE)
        self.textLabel.textAlignment = .Center
        self.textLabel.lineBreakMode = .ByWordWrapping
        self.textLabel.numberOfLines = 0
        self.textLabel.colorType = .TEXT
        self.textLabel.fitHeight()
        
        self.addSubview(textLabel)
        
        self.resetColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
