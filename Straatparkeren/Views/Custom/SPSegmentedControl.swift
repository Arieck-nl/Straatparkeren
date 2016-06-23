//
//  SPSegmentedControl.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 23-06-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SPSegmentedControl: UIView {
    
    static let selectedColor = DefaultsController.sharedInstance.getCurrentTheme().BACKGROUND
    static let unselectedColor = DefaultsController.sharedInstance.getCurrentTheme().TEXT
    
    var onValueChanged : ((String) -> Void)?
    internal var currentValue : String?
    
    func setValues(keys : [String], images : [UIImage] = [], selected : String){
        
        self.removeSubviews()
        
        let btnWidth = self.frame.width / CGFloat(keys.count)
        let btnHeight = self.frame.height
        
        for (i,value) in keys.enumerate(){
            
            let segment = SPSegmentButton(frame: CGRect(
                x: btnWidth * CGFloat(i),
                y: 0,
                w: btnWidth,
                h: btnHeight), image: images[i], text: value)
            
            
            segment.addTapGesture(action: { (UITapGestureRecognizer) in
                let key = segment.btnText?.text
                if self.onValueChanged != nil && self.currentValue != key {
                    self.setSelectedFor(key!)
                }
            })
            
            if value == selected{
                self.currentValue = value
                segment.selected = true
            }
            
            
            self.addSubview(segment)
        }
        
    }
    
    func setSelectedFor(key : String){
        for subview in self.subviews{
            if subview.isKindOfClass(SPSegmentButton){
                let segment = subview as! SPSegmentButton
                if segment.btnText?.text == key{
                    segment.selected = true
                    self.currentValue = key
                    self.onValueChanged!(key)
                }else{
                    segment.selected = false
                }
            }
        }
    }
    
    func setOnValueChangedListerer(listener : (String) -> Void){
        onValueChanged = listener
    }
    
}

class SPSegmentButton : SPNavButtonView{
    
    override init(frame : CGRect, image : UIImage, text : String, iconLeft : Bool = false) {
        super.init(frame: frame, image: image, text: text, iconLeft: iconLeft)
        
        self.btnIcon!.frame = CGRectMake(
            D.SPACING.REGULAR,
            D.SPACING.REGULAR,
            self.frame.width - (D.SPACING.REGULAR * 2),
            self.frame.height - (D.SPACING.REGULAR * 2))
        
        self.colorType = .BACKGROUND
        self.opacity = S.OPACITY.REGULAR
        
        self.btnText?.hidden = true
        
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal var tempSelected : Bool = false
    
    var selected: Bool{
        set{
            self.tempSelected = newValue
            if(self.tempSelected){
                self.layer.borderColor = C.BUTTON.DARK.CGColor
            }else{
                self.layer.borderColor = UIColor.clearColor().CGColor
            }
        }
        get{
            return self.tempSelected
        }
    }

}
