//
//  MapSearchResultViewCell.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 19/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class MapSearchResultViewCell: UITableViewCell {
    
    var titleLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel = UILabel(x: D.SPACING.REGULAR, y: (D.SEARCH_CELL.HEIGHT - D.FONT.XXLARGE) / 2, w: 100, h: self.frame.height, fontSize: D.FONT.XXLARGE)
        titleLabel?.textColor = DefaultsController.sharedInstance.getCurrentTheme().TEXT
        self.addSubview(titleLabel!)
        
        self.backgroundColor = DefaultsController.sharedInstance.getCurrentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.DARK)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetColors(){
        titleLabel?.textColor = DefaultsController.sharedInstance.getCurrentTheme().TEXT
        self.backgroundColor = DefaultsController.sharedInstance.getCurrentTheme().BACKGROUND.colorWithAlphaComponent(S.OPACITY.DARK)

    }
}
