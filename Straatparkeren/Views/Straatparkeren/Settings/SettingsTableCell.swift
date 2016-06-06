//
//  SettingsTableCell.swift
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
        titleLabel.textColor = ThemeController.sharedInstance.currentTheme().TEXT
        self.addSubview(titleLabel)
        
        subtitleLabel = UILabel(
            x: D.SPACING.REGULAR,
            y: D.SPACING.REGULAR + titleLabel.frame.y + D.FONT.XXXLARGE,
            w: self.frame.width - (D.SPACING.REGULAR * 2) - D.SETTINGS.SWITCH_HEIGHT,
            h: 100,
            fontSize: D.FONT.XLARGE
        )
        subtitleLabel.textColor = ThemeController.sharedInstance.currentTheme().TEXT.colorWithAlphaComponent(S.OPACITY.DARK)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .ByWordWrapping
        
        self.addSubview(subtitleLabel)
        
        switchView = UISwitch(frame: CGRect(
            x: frame.width - D.SPACING.REGULAR - D.SETTINGS.SWITCH_HEIGHT,
            y: (D.SETTINGS.ROW_HEIGHT - D.SETTINGS.SWITCH_HEIGHT) / 2,
            w: D.SETTINGS.SWITCH_HEIGHT,
            h: D.SETTINGS.SWITCH_HEIGHT
            ))
        switchView.tintColor = ThemeController.sharedInstance.currentTheme().TEXT
        switchView.thumbTintColor = ThemeController.sharedInstance.currentTheme().TEXT
        switchView.transform = CGAffineTransformMakeScale(1.5, 1.5)
        
        self.addSubview(switchView)
        
        self.addSubview(subtitleLabel)
        
        segmentedView = SPMultiSegmentedView(frame: CGRect(
            x: frame.width - D.SPACING.REGULAR - (D.FONT.XXXLARGE * 3),
            y: 0,
            w: (D.SETTINGS.SEGMENTED_HEIGHT * 3),
            h: (D.SETTINGS.SEGMENTED_HEIGHT * 2)
            ))
        
        self.addSubview(segmentedView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetColors(){
        titleLabel?.textColor = ThemeController.sharedInstance.currentTheme().TEXT
        self.backgroundColor = ThemeController.sharedInstance.currentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.DARK)
        
    }
}
