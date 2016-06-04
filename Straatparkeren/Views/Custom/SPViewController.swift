//
//  SPViewController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 10/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class SPViewController: UIViewController, ThemeProtocol, InterfaceModeProtocol {
    
    var SPNavBar : SPNavigationBar?
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setDayMode), name: N.DAY_MODE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setNightMode), name: N.NIGHT_MODE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setMinimalMode), name: N.MINIMAL_MODE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setMediumMode), name: N.MEDIUM_MODE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setMaximalMode), name: N.MAXIMAL_MODE, object: nil)
        setToolbar()
    }
    
    func setToolbar(){
        SPNavBar = SPNavigationBar(frame: CGRectMake(0, 0, D.SCREEN_WIDTH, D.NAVBAR.HEIGHT))
        
//        let nextView : UIButton = UIButton(x: 0, y: 0, w: 50, h: 50, target: self, action: #selector(SPViewController.itemSelected))
//        nextView.backgroundColor = C.PRIMARY.REGULAR
//        SPNavBar.addSubview(nextView)
        
        view.addSubview(SPNavBar!)
    }
    
    func itemSelected(){
        print("this")
        self.popVC()
        self.pushVC(SpringboardViewController())
    }
    
    func setCustomToolbarHidden(hidden : Bool){
        SPNavBar!.hidden = hidden
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Implement protocol methods
    
    func setDayMode(){
        fatalError("Must override method")
    }
    
    func setNightMode(){
        fatalError("Must override method")
    }
    
    func setMinimalMode(){
        fatalError("Must override method")
    }
    
    func setMediumMode(){
        fatalError("Must override method")
    }
    
    func setMaximalMode(){
        fatalError("Must override method")
    }
    
    

}
