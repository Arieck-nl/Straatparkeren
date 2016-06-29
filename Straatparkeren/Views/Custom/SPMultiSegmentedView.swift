//
//  SPMultiSegmentedView.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 06-06-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SPMultiSegmentedView: UIView {
    
    static let selectedColor = DefaultsController.sharedInstance.getCurrentTheme().BACKGROUND
    static let unselectedColor = DefaultsController.sharedInstance.getCurrentTheme().TEXT
    
    internal var selectedValues : [String] = []
    internal var keyValues : [String] = []
    
    var rightLabel : UILabel?
        
    internal func toggleValue(value : String){
        if(self.selectedValues.contains(value)){
            self.selectedValues.removeObject(value)
        }else{
            self.selectedValues.append(value)
        }
    }
    
    func setValues(keys : [String], values : [Bool], rightText : String = "", tapHandler: () -> Void){

        self.removeSubviews()
        self.keyValues = keys
        let btnWidth = self.frame.width / CGFloat(values.count)
        let btnHeight = self.frame.height / 2
        var keyCount = 0
        for (i,value) in values.enumerate(){
            let segment = SPMultiSegmentButton(frame: CGRect(
                x: btnWidth * CGFloat(i),
                y: 0,
                w: btnWidth,
                h: btnHeight))
            segment.setTitle(keys[i], forState: .Normal)
            
            if value {self.selectedValues.append(keys[i])}
            segment.selected = value
            keyCount += 1
            
            
            segment.addTapGesture(action: { (UITapGestureRecognizer) in
                self.toggleValue(segment.currentTitle!)
                tapHandler()
                segment.selected = !segment.selected
            })
            
            self.addSubview(segment)
        }
        
        if(rightText != ""){
            rightLabel = UILabel(
                x: 0,
                y: (frame.height / 2) + D.SPACING.SMALL,
                w: frame.width,
                h: 100,
                fontSize: D.FONT.XXLARGE
            )
            rightLabel!.text = rightText
            rightLabel!.textAlignment = .Center
            rightLabel?.colorType = .TEXT
            rightLabel!.fitHeight()
            
            self.addSubview(rightLabel!)
            self.resetColor(false)
        }

    }
    
    func getValues() -> [String]{
        return self.keyValues
    }
    
    func getSelectedValues() -> [String]{
        return self.selectedValues
    }
    
}

class SPMultiSegmentButton : UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel!.font = self.titleLabel!.font.fontWithSize(D.FONT.XXLARGE)
        self.titleLabel?.colorType = .TEXT
        self.putColor()
        
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 3
        self.layer.borderColor = C.BUTTON.LIGHT.CGColor
        self.colorType = .TEXT
        self.opacity = S.OPACITY.LIGHT
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var selected: Bool {
        
        // Act to setting selected
        didSet {
            if(super.selected){
                self.layer.borderColor = C.BUTTON.DARK.CGColor
            }else{
                self.layer.borderColor = UIColor.clearColor().CGColor
            }
        }
    }
    
}
