//
//  Extensions.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 07-06-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import Foundation
import UIKit


public enum COLOR_TYPE : Int{
    case TEXT, BACKGROUND, BUTTON, SWITCH, HIGH_CONTRAST
    
    var color: UIColor {
        let theme = DefaultsController.sharedInstance.getCurrentTheme()
        return theme.getColorForType(self)
    }
}

private var storedColorType : UInt8 = 0
private var storedOpacity : UInt8 = 0

extension UIView{
    
    // UIView extension to provide default hide and show with animation
    func show(){
        if(self.hidden){
            self.alpha = 0.0
            self.hidden = false
            
            self.animate(
                duration: ANI.DUR.FAST,
                animations: {
                    self.alpha = 1.0
                },
                completion: { (Bool) in
            })
        }
        
        
        
    }
    
    // Pass along completionHandler
    func hide(completionHandler : Bool -> Void){
        if(!self.hidden){
            self.alpha = 1.0
            self.animate(
                duration: ANI.DUR.FAST,
                animations: {
                    self.alpha = 0.0
                },
                completion: { (completed) in
                    self.hidden = true
                    completionHandler(completed)
            })
        }
    }
    
    // Extension helpers for theme changing
    var colorType : COLOR_TYPE? {
        get {
            if let getColorType = objc_getAssociatedObject(self, &storedColorType) {
                return COLOR_TYPE(rawValue: getColorType.integerValue)
            }else{
                return nil
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &storedColorType, newValue?.hashValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var opacity : CGFloat{
        get {
            if let getOpacity = objc_getAssociatedObject(self, &storedOpacity){
                return CGFloat(getOpacity.floatValue)
            }else{
                return 1.0
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &storedOpacity, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    func resetColor(animated : Bool = true){
        self.setColor(animated)
        for subview in self.subviews{
            subview.resetColor(animated)
        }
    }
    
    func setColor(animated : Bool = true){
        if(colorType != nil){
            let duration = animated ? ANI.DUR.GRADUALLY : 0
            self.animate(
                duration: duration,
                animations: {
                    self.backgroundColor = self.colorType?.color.colorWithAlphaComponent(self.opacity)
                    self.tintColor = self.colorType?.color.colorWithAlphaComponent(self.opacity)
                },
                completion: { (Bool) in
            })
            
        }
    }
}

extension UITextView{
    override func setColor(animated : Bool = true){
        if(colorType != nil){
            self.animate(
                duration: ANI.DUR.GRADUALLY,
                animations: {
                    self.textColor = self.colorType?.color
                },
                completion: { (Bool) in
            })
            
        }
    }
}

extension UISwitch{
    override func setColor(animated : Bool = true){
        if (colorType != nil) && (self.tintColor != self.colorType?.color) {
            UIView.transitionWithView(self, duration: (ANI.DUR.GRADUALLY / 2), options: .TransitionCrossDissolve, animations: {
                self.alpha = 0
                }, completion: { (Bool) in
                    self.tintColor = self.colorType?.color
                    self.thumbTintColor = self.colorType?.color
                    UIView.transitionWithView(self, duration: (ANI.DUR.GRADUALLY / 2), options: .TransitionCrossDissolve, animations: {
                        self.alpha = 1.0
                        }, completion: { (Bool) in
                            
                    })
            })
        }
    }
    
    func putColor(){
        self.tintColor = self.colorType?.color
        self.thumbTintColor = self.colorType?.color
    }
}

extension UIImageView{
    override func setColor(animated : Bool = true){
        if(colorType != nil){
            self.animate(
                duration: ANI.DUR.GRADUALLY,
                animations: {
                    self.tintColor = self.colorType?.color.colorWithAlphaComponent(self.opacity)
                },
                completion: { (Bool) in
            })
            
        }
    }
}

extension UILabel{
    override func setColor(animated : Bool = true){
        if(colorType != nil){
            UIView.transitionWithView(self, duration: ANI.DUR.GRADUALLY, options: .TransitionCrossDissolve, animations: {
                self.textColor = self.colorType?.color
                }, completion: { (Bool) in
            })
        }
    }
}

extension UIButton{
    //    override func setColor(){
    //        if(colorType != nil){
    //            UIView.transitionWithView(self, duration: ANI.DUR.GRADUALLY, options: .TransitionCrossDissolve, animations: {
    //                self.setTitleColor(self.titleLabel?.colorType?.color, forState: .Normal)
    //                self.setBackgroundColor((self.colorType?.color.colorWithAlphaComponent(self.opacity))!, forState: .Normal)
    //                }, completion: { (Bool) in
    //            })
    //        }
    //    }
    
    func putColor(){
        self.setTitleColor(self.titleLabel?.colorType?.color, forState: .Normal)
    }
}