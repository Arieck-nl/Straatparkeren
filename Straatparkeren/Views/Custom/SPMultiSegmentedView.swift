//
//  SPMultiSegmentedView.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 06-06-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SPMultiSegmentedView: UIView {
    
    static let selectedColor = ThemeController.sharedInstance.currentTheme().BACKGROUND
    static let unselectedColor = ThemeController.sharedInstance.currentTheme().TEXT
    
    internal var values : [Double] = []
    
    var rightLabel : UILabel?
        
    internal func toggleValue(value : Double){
        if(self.values.contains(value)){
            self.values.removeObject(value)
        }else{
            self.values.append(value)
        }
    }
    
    func setValues(values : [String], rightText : String = "", tapHandler: () -> Void){
        let btnWidth = self.frame.width / CGFloat(values.count)
        let btnHeight = self.frame.height / 2
        
        for (i,value) in values.enumerate(){
            let segment = SPMultiSegmentButton(frame: CGRect(
                x: btnWidth * CGFloat(i),
                y: 0,
                w: btnWidth,
                h: btnHeight))
            segment.setTitle(value, forState: .Normal)
            
            
            segment.addTapGesture(action: { (UITapGestureRecognizer) in
                self.toggleValue(Double(segment.currentTitle!)!)
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
            rightLabel?.textColor = ThemeController.sharedInstance.currentTheme().TEXT
            rightLabel!.fitHeight()
            
            self.addSubview(rightLabel!)
        }

    }
    
    func getSelectedValues() -> [Double]{
        return self.values
    }
    
}

class SPMultiSegmentButton : UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel!.font = self.titleLabel!.font.fontWithSize(D.FONT.XXLARGE)
        self.setTitleColor(SPMultiSegmentedView.unselectedColor, forState: .Normal)
        self.setTitleColor(SPMultiSegmentedView.selectedColor, forState: .Selected)
        
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = SPMultiSegmentedView.unselectedColor.CGColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var selected: Bool {
        
        didSet {
            if(selected){
                self.layer.borderColor = SPMultiSegmentedView.selectedColor.CGColor
                self.backgroundColor = SPMultiSegmentedView.unselectedColor
            }else{
                self.layer.borderColor = SPMultiSegmentedView.unselectedColor.CGColor
                self.backgroundColor = SPMultiSegmentedView.selectedColor
            }
        }
    }
    
}
