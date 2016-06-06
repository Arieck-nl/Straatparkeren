//
//  SettingsItem.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 05-06-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import Foundation
import MapKit

class SettingsItem{
    
    var title           : String!
    var subtitle        : String?
    var switchHidden    : Bool!
    var switchValue     : Bool?
    var tapEvent        : Selector?
    var segmentedValues : [String]?
    var segmentedLabel  : String?
    
    
    
    init(title : String, subtitle : String?, switchHidden : Bool, switchValue : Bool, tapEvent : Selector?, segmentedValues : [String]? = nil, segmentedLabel : String? = ""){
        self.title = title
        self.subtitle = subtitle
        self.switchHidden = switchHidden
        self.switchValue = switchValue
        self.tapEvent = tapEvent
        self.segmentedValues = segmentedValues
        self.segmentedLabel = segmentedLabel
    }
    
}
