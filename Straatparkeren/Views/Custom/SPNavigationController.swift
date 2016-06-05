//
//  SPNavigationController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 10/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SPNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        setNavigationBarHidden(true, animated: false)
        self.modalPresentationStyle = .OverCurrentContext
    }

}
