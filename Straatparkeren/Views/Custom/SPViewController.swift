//
//  SPViewController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 10/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SPViewController: UIViewController {
    
    let SPNavBar : SPNavigationBar = SPNavigationBar()
    
    override func viewDidLoad() {
        setToolbar()
    }
    
    func setToolbar(){
        SPNavBar.frame = CGRectMake(0, 0, D.SCREEN_WIDTH, D.NAVBAR.HEIGHT)
        
        let nextView : UIButton = UIButton(x: 0, y: 0, w: 50, h: 50, target: self, action: #selector(SPViewController.itemSelected))
        nextView.backgroundColor = C.PRIMARY.REGULAR
        SPNavBar.addSubview(nextView)
        
        view.addSubview(SPNavBar)
    }
    
    func itemSelected(){
        print("this")
        self.popVC()
        self.pushVC(SpringboardViewController())
    }
    
    func setCustomToolbarHidden(hidden : Bool){
        SPNavBar.hidden = hidden
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
