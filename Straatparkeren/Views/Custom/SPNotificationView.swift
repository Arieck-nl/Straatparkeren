//
//  SPNotificationView.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 06-06-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SPNotificationView: UIView {
    
    private var titleLabel      : UILabel?
    private var iconView        : UIImageView?
    
    private var defaultFrame    : CGRect!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.defaultFrame = frame
        self.hidden = true
        
        self.iconView = UIImageView(frame: CGRect(
            x: D.SPACING.REGULAR,
            y: D.SPACING.REGULAR,
            w: frame.height - (D.SPACING.REGULAR * 2),
            h: frame.height - (D.SPACING.REGULAR * 2)
            ))
        self.addSubview(self.iconView!)
        
        self.backgroundColor = C.LIGHT
        titleLabel = UILabel(
            x: self.iconView!.frame.width + self.iconView!.frame.x + D.SPACING.REGULAR,
            y: (frame.height - D.FONT.XXXLARGE) / 2,
            w: frame.width - self.iconView!.frame.width - (D.SPACING.SMALL * 2),
            h: 100, fontSize: D.FONT.XXXLARGE)
        titleLabel?.textColor = C.DARK
        titleLabel?.fitHeight()
        self.addSubview(titleLabel!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func internalShow(title : String, icon : UIImage = UIImage(named: "StraatparkerenIcon")!){
        if(self.hidden){
            self.iconView?.image = icon
            
            self.titleLabel!.text = title
            self.titleLabel!.fitHeight()
            self.hidden = false
            
            self.animate(
                duration: ANI.DUR.REGULAR,
                animations: {
                    self.frame.offsetInPlace(dx: 0, dy: self.frame.height)
                },
                completion: { (Bool) in
                    self.frame = self.defaultFrame.offsetBy(dx: 0, dy: self.frame.height)
                    NSTimer.scheduledTimerWithTimeInterval(ANI.NOTIFICATION_DISMISS, target: self, selector: #selector(self.internalHide), userInfo: nil, repeats: false)
            })
        }
        
        
        
    }
    
    func internalHide(){
        if(!self.hidden){
            self.animate(
                duration: ANI.DUR.REGULAR,
                animations: {
                    self.frame.offsetInPlace(dx: 0, dy: -self.frame.height)
                },
                completion: { (Bool) in
                    self.frame = self.defaultFrame
                    self.hidden = true
            })
        }
    }
    
    func resetColors(){
        self.backgroundColor = DefaultsController.sharedInstance.getCurrentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.DARK)
        titleLabel?.textColor = DefaultsController.sharedInstance.getCurrentTheme().TEXT
        
    }
    
}
