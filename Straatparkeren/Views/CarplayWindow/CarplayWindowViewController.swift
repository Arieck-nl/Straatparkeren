//
//  CarplayWindowViewController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 10/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class CarplayWindowViewController: UIViewController {
    
    let dismissInterval         : Double = 180
    var dismissTimer            : NSTimer?
    
    var carplayControl          : UIView?
    var currentTimeLabel        : UILabel?
    var window                  : UIView?
    var homeBtn                 : UIImageView?
    var springboardNavVC        : SPNavigationController?
    var notificationView        : SPNotificationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.displayNotification), name: N.DESTINATION_TRIGGER, object: nil)
        
        carplayControl = UIView(frame: CGRect(x: 0, y: 0, w: D.CARPLAY.WIDTH, h: D.SCREEN_HEIGHT))
        carplayControl?.backgroundColor = UIColor.blackColor()
        view.addSubview(carplayControl!)
        
        currentTimeLabel = UILabel(frame: CGRect(x: 0, y: ((carplayControl?.frame.height)! / 2) - D.FONT.XXLARGE, width: (carplayControl?.frame.width)!, height: 100))
        currentTimeLabel?.textColor = UIColor.whiteColor()
        currentTimeLabel?.font = currentTimeLabel?.font.fontWithSize(D.FONT.XXLARGE)
        currentTimeLabel?.textAlignment = .Center
        
        currentTimeLabel?.addTapGesture(action: { (UITapGestureRecognizer) in
            LocationDependentController.sharedInstance.sentDestinationTrigger(STR.notification_default)
        })
        
        updateClock()
        NSTimer.scheduledTimerWithTimeInterval(60.0,
                                               target: self,
                                               selector: #selector(CarplayWindowViewController.updateClock),
                                               userInfo: nil,
                                               repeats: true)
        
        
        carplayControl?.addSubview(currentTimeLabel!)
        
        
        
        homeBtn = UIImageView(frame: CGRect(x: (D.CARPLAY.WIDTH - D.CARPLAY.BTN_WIDTH) / 2, y: D.SCREEN_HEIGHT - D.CARPLAY.BTN_WIDTH - D.SPACING.REGULAR, w: D.CARPLAY.BTN_WIDTH, h: D.CARPLAY.BTN_WIDTH))
        homeBtn?.image = UIImage(named: "CarplayHome")
        homeBtn?.addTapGesture(action: { (UITapGestureRecognizer) in
            self.springboardNavVC!.popToRootViewControllerAnimated(true)
        })
        carplayControl?.addSubview(homeBtn!)
        
        let rightBorder : CALayer = CALayer()
        rightBorder.backgroundColor = UIColor.grayColor().CGColor
        rightBorder.frame = CGRectMake(D.CARPLAY.WIDTH - D.CARPLAY.BORDER_WIDTH, 0, D.CARPLAY.BORDER_WIDTH, D.SCREEN_HEIGHT);
        carplayControl?.layer.addSublayer(rightBorder)
        
        
        window = UIView(frame: CGRect(x: (carplayControl?.bounds.width)!, y: 0, w: D.SCREEN_WIDTH, h: D.SCREEN_HEIGHT))
        window?.backgroundColor = UIColor.blackColor()
        
        view.addSubview(window!)
        
        let springboardVC = SpringboardViewController()
        springboardNavVC = SPNavigationController.init(rootViewController: springboardVC)
        springboardVC.view.frame = (window?.frame)!
        
        window!.addSubview(springboardNavVC!.view)
        addAsChildViewController(springboardNavVC!, toView: window!)
        springboardNavVC!.didMoveToParentViewController(self)
        self.addGestures()
        
        self.notificationView = SPNotificationView(frame: CGRect(
            x: 0,
            y: -D.NAVBAR.HEIGHT,
            w: D.SCREEN_WIDTH,
            h: D.NAVBAR.HEIGHT
            ))
        
        self.notificationView.addTapGesture { (UITapGestureRecognizer) in
            self.notificationView.internalHide()
            LocationDependentController.sharedInstance.sentLocationTrigger(.NOTIFICATION, value: "")
        }
        self.window!.addSubview(notificationView)
    }
    
    // Gestures for debugging purposes
    func addGestures(){
        let interfaceController = InterfaceModeController.sharedInstance
        
        self.carplayControl!.addSwipeGesture(direction: .Down) { (Swiped) -> () in
            if(interfaceController.currentMode() == I_MODE.MAXIMAL){
                interfaceController.setMode(.MEDIUM)
            }else if(interfaceController.currentMode() == I_MODE.MEDIUM){
                interfaceController.setMode(.MINIMAL)
            }
        }
        self.carplayControl!.addSwipeGesture(direction: .Up) { (Swiped) -> () in
            if(interfaceController.currentMode() == I_MODE.MINIMAL){
                interfaceController.setMode(.MEDIUM)
            }else if(interfaceController.currentMode() == I_MODE.MEDIUM){
                interfaceController.setMode(.MAXIMAL)
            }
        }
        
        let themeController = ThemeController.sharedInstance
        
        self.carplayControl!.addSwipeGesture(direction: .Left) { (Swiped) -> () in
            themeController.setTheme(.NIGHT)
        }
        self.carplayControl!.addSwipeGesture(direction: .Right) { (Swiped) -> () in
            themeController.setTheme(.DAY)
        }
    }
    
    func dismissCurrentVC(){
        self.springboardNavVC!.popToRootViewControllerAnimated(true)
    }
    
    func dissmissCurrentVCFromTimer(){
        if DefaultsController.sharedInstance.isAutomaticShutdownOn(){
            self.dismissCurrentVC()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //dismiss VC after X amount of time
        self.dismissTimer?.invalidate()
        self.dismissTimer = nil
        
        // TODO: use defaults for this
        if DefaultsController.sharedInstance.isAutomaticShutdownOn(){
            self.dismissTimer = NSTimer.scheduledTimerWithTimeInterval(self.dismissInterval, target: self, selector: #selector(CarplayWindowViewController.dissmissCurrentVCFromTimer), userInfo: nil, repeats: false)
        }
    }
    
    func displayNotification(notification: NSNotification){
        
        let userInfo : NSDictionary = notification.userInfo!
        
        if let title = userInfo["value"] as? String{
            notificationView.internalShow(title)
        }
        
        
    }
    
    func updateClock(){
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour,.Minute], fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        
        currentTimeLabel?.text = String(format: "%02d", hour) + ":" + String(format: "%02d", minutes)
    }
}
