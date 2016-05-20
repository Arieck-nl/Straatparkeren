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
        btnIcon?.image = image
        btnIcon?.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(btnIcon!)
        
        btnText = UILabel(x: D.SPACING.REGULAR, y: frame.height - D.SPACING.REGULAR - D.FONT.XXLARGE, w: frame.width - (D.SPACING.REGULAR * 2), h: 100, fontSize: D.FONT.XXLARGE)
        btnText!.text = text
        btnText?.fitHeight()
        btnText?.textColor = C.TEXT
        btnText!.textAlignment = .Center
        self.addSubview(btnText!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
