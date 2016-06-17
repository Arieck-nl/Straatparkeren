//
//  Extensions.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 07-06-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import Foundation
import UIKit

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
    
    func resetColor(){
        let defaults = DefaultsController.sharedInstance
        
        if self.backgroundColor != nil{
            
            let alpha = CIColor(color: (self.backgroundColor)!).alpha
            print(alpha)
            self.backgroundColor = self.backgroundColor?.colorWithAlphaComponent(1.0)
            
            if self.backgroundColor!.isEqual(defaults.getCurrentTheme().BACKGROUND){
                self.backgroundColor = defaults.getCurrentTheme().TEXT.colorWithAlphaComponent(alpha)
            }else if self.backgroundColor!.isEqual(defaults.getCurrentTheme().TEXT){
                self.backgroundColor = defaults.getCurrentTheme().BACKGROUND.colorWithAlphaComponent(alpha)
            }
        }
        
        
        if self.tintColor != nil{
            
            let alpha = CIColor(color: (self.tintColor)!).alpha
            self.tintColor = self.tintColor?.colorWithAlphaComponent(1.0)
            
            if self.tintColor!.isEqual(defaults.getCurrentTheme().BACKGROUND){
                self.tintColor = defaults.getCurrentTheme().TEXT.colorWithAlphaComponent(alpha)
            }else if self.tintColor!.isEqual(defaults.getCurrentTheme().TEXT){
                self.tintColor = defaults.getCurrentTheme().BACKGROUND.colorWithAlphaComponent(alpha)
            }
        }
    }
}

extension UITextView{
    override func resetColor(){
        super.resetColor()
        let defaults = DefaultsController.sharedInstance
        
        if self.textColor != nil{
            
            let alpha = CIColor(color: (self.textColor)!).alpha
            print(alpha)
            self.textColor = self.textColor?.colorWithAlphaComponent(1.0)
            
            if self.textColor!.isEqual(defaults.getCurrentTheme().BACKGROUND){
                self.textColor = defaults.getCurrentTheme().TEXT.colorWithAlphaComponent(alpha)
            }else if self.textColor!.isEqual(defaults.getCurrentTheme().TEXT){
                self.textColor = defaults.getCurrentTheme().BACKGROUND.colorWithAlphaComponent(alpha)
            }
        }
    }

}