//
//  SettingsTableself.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 05-06-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SettingsTableCell: UITableViewCell {
    
    var titleLabel      : UILabel!
    var subtitleLabel   : UILabel!
    var switchView      : UISwitch!
    var segmentedView   : SPMultiSegmentedView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        
        titleLabel = UILabel(
            x: D.SPACING.REGULAR,
            y: D.SPACING.REGULAR,
            w: self.frame.width - (D.SPACING.REGULAR * 2),
            h: 100,
            fontSize: D.FONT.XXXLARGE
        )
        titleLabel.colorType = .TEXT
        self.addSubview(titleLabel)
        
        subtitleLabel = UILabel(
            x: D.SPACING.REGULAR,
            y: D.SPACING.REGULAR + titleLabel.frame.y + D.FONT.XXXLARGE,
            w: self.frame.width - (D.SPACING.REGULAR * 2) - D.SETTINGS.SWITCH_HEIGHT,
            h: 100,
            fontSize: D.FONT.XLARGE
        )
        
        subtitleLabel.colorType = .TEXT
        subtitleLabel.opacity = S.OPACITY.DARK
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .ByWordWrapping
        
        self.addSubview(subtitleLabel)
        
        switchView = UISwitch(frame: CGRect(
            x: frame.width - D.SPACING.REGULAR - D.SETTINGS.SWITCH_HEIGHT,
            y: (D.SETTINGS.ROW_HEIGHT - D.SETTINGS.SWITCH_HEIGHT) / 2,
            w: D.SETTINGS.SWITCH_HEIGHT,
            h: D.SETTINGS.SWITCH_HEIGHT
            ))
        switchView.colorType = .SWITCH
        switchView.putColor()
        switchView.transform = CGAffineTransformMakeScale(D.ELEMENT.MULTIPLIER, D.ELEMENT.MULTIPLIER)
        
        self.addSubview(switchView)
        
        self.addSubview(subtitleLabel)
        
        segmentedView = SPMultiSegmentedView(frame: CGRect(
            x: frame.width - D.SPACING.REGULAR - (D.FONT.XXXLARGE * 3),
            y: 0,
            w: (D.SETTINGS.SEGMENTED_HEIGHT * 3),
            h: (D.SETTINGS.SEGMENTED_HEIGHT * 2)
            ))
        
        self.resetColor()
        self.addSubview(segmentedView)
        
    }
    
    func resetViews(){
        let segmentedWidth = D.SETTINGS.SEGMENTED_HEIGHT * CGFloat(self.segmentedView.getValues().count)
        
        self.segmentedView.frame = CGRect(
            x: self.frame.width - D.SPACING.REGULAR - segmentedWidth,
            y: ((self.frame.height - (D.SETTINGS.SEGMENTED_HEIGHT * 2)) / 2) + D.SPACING.REGULAR,
            w: self.segmentedView.frame.width,
            h: self.frame.height
        )
        
        self.titleLabel.frame = CGRect(
            x: self.titleLabel.frame.x,
            y: self.titleLabel.frame.y,
            w: self.frame.width - (D.SPACING.REGULAR * 2) - D.SETTINGS.SWITCH_HEIGHT - segmentedWidth,
            h: self.titleLabel.frame.height
        )
        self.titleLabel.fitSize()
        
        self.subtitleLabel.frame = CGRect(
            x: self.subtitleLabel.frame.x,
            y: self.subtitleLabel.frame.y,
            w: self.frame.width - (D.SPACING.REGULAR * 2) - D.SETTINGS.SWITCH_HEIGHT - segmentedWidth,
            h: self.subtitleLabel.frame.height
        )
        self.subtitleLabel.fitHeight()
        
        self.switchView.frame = CGRect(
            x: self.frame.width - D.SPACING.REGULAR - D.SETTINGS.SWITCH_HEIGHT,
            y: self.switchView.frame.y,
            w: self.switchView.frame.width,
            h: self.switchView.frame.height
        )
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
