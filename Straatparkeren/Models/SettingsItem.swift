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
    var segmentedKeys   : [String]?
    var segmentedValues : [Bool]?
    var segmentedLabel  : String?
    
    
    
    init(title : String, subtitle : String?, switchHidden : Bool, switchValue : Bool, tapEvent : Selector?, segmentedKeys : [String]? = nil, segmentedValues : [Bool]? = nil, segmentedLabel : String? = ""){
        self.title = title
        self.subtitle = subtitle
        self.switchHidden = switchHidden
        self.switchValue = switchValue
        self.tapEvent = tapEvent
        self.segmentedKeys = segmentedKeys
        self.segmentedValues = segmentedValues
        self.segmentedLabel = segmentedLabel
    }
    
}
