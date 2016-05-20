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

    init(frame: CGRect, text : String, btnText : String) {
        super.init(frame: frame)
        
        self.backgroundColor = C.BACKGROUND.colorWithAlphaComponent(S.OPACITY.XDARK)
        
        self.dismissBtn.setTitle(btnText, forState: .Normal)
        self.dismissBtn.titleLabel!.font = self.dismissBtn.titleLabel!.font.fontWithSize(D.FONT.XXXLARGE)
        self.dismissBtn.titleLabel?.textAlignment =  .Center
        self.dismissBtn.frame = CGRect(x: 0, y: D.SCREEN_HEIGHT - D.BTN.HEIGHT.REGULAR - D.SPACING.LARGE, w: D.SCREEN_WIDTH, h: D.BTN.HEIGHT.REGULAR)
        
        self.dismissBtn.titleLabel?.textColor = C.TEXT
        self.dismissBtn.backgroundColor = C.TEXT.colorWithAlphaComponent(S.OPACITY.LIGHT)
        self.dismissBtn.addTapGesture { (gesture) -> () in
            self.removeFromSuperview()
        }
        self.addSubview(dismissBtn)
        
        
        self.textLabel.frame = CGRect(x: self.frame.x + D.SPACING.XXLARGE, y: self.frame.y + D.SPACING.XXLARGE, w: D.SCREEN_WIDTH - (D.SPACING.XXLARGE * 2), h: self.dismissBtn.frame.y - D.SPACING.REGULAR)
        self.textLabel.text = text
        self.textLabel.font = self.textLabel.font.fontWithSize(D.FONT.XXLARGE)
        self.textLabel.textAlignment = .Center
        self.textLabel.lineBreakMode = .ByWordWrapping
        self.textLabel.numberOfLines = 0
        self.textLabel.textColor = C.TEXT
        
        self.addSubview(textLabel)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
