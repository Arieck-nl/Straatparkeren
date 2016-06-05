//
//  AppModel.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 09/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import Foundation

class SpringboardApp : NSObject {
    
    var title : String!
    var icon : String!
    var url : String!
    
    init(title: String, icon: String, url: String) {
        self.title = title
        self.icon = icon
        self.url = url
    }
    
}
