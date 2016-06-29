//
//  SPViewController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 10/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

// Default project viewcontroller
class SPViewController: UIViewController, ThemeProtocol, InterfaceModeProtocol {
    
    var SPNavBar : SPNavigationBar?
    
    override func viewDidLoad() {
        // Require every viewcontroller to listen to interface changing controllers
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setDayMode), name: N.DAY_MODE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setNightMode), name: N.NIGHT_MODE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setMinimalMode), name: N.MINIMAL_MODE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setMediumMode), name: N.MEDIUM_MODE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setMaximalMode), name: N.MAXIMAL_MODE, object: nil)
        setToolbar()
    }
    
    override func viewDidAppear(animated: Bool) {
        let window = view.window!
        let gr0 = window.gestureRecognizers![0] as UIGestureRecognizer
        let gr1 = window.gestureRecognizers![1] as UIGestureRecognizer
        gr0.delaysTouchesBegan = false
        gr1.delaysTouchesBegan = false
    }
    
    func setToolbar(){
        SPNavBar = SPNavigationBar(frame: CGRectMake(0, 0, D.SCREEN_WIDTH, D.NAVBAR.HEIGHT))
        view.addSubview(SPNavBar!)
    }
    
    func setCustomToolbarHidden(hidden : Bool){
        SPNavBar!.hidden = hidden
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Require children to implement protocol methods
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
