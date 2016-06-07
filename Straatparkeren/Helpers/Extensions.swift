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
}