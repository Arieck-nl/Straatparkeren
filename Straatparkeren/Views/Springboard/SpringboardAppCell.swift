//
//  SpringboardAppCell.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 10/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class SpringboardAppCell : UICollectionViewCell{
    
    var appImage : UIImageView?
    var appLabel : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        appImage = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        addSubview(appImage!)
        
        appLabel = UILabel(frame: CGRect(x: -D.SPACING.XXLARGE, y: frame.height + D.SPACING.REGULAR, width: frame.width + (D.SPACING.XXLARGE * 2), height: 100))
        appLabel?.textColor = UIColor.whiteColor()
        appLabel?.font = appLabel?.font.fontWithSize(D.FONT.XXLARGE)
        appLabel?.textAlignment = NSTextAlignment.Center
        addSubview(appLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setIcon(img : String){
        appImage?.image = UIImage(named: img)
    }
    
    func setTitle(title : String){
        appLabel?.text = title
        appLabel?.fitHeight()
    }
    
    
    
    
}
