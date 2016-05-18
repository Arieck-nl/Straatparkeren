//
//  SPNavigationBar.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 11/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SPNavigationBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = C.BACKGROUND.colorWithAlphaComponent(S.OPACITY.DARK)

    }
    
    func itemSelected(){
        print("got it")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTab(title: String, icon: String){
        
    }
    
}
