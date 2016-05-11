//
//  CarplayWindowViewController.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 10/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

class CarplayWindowViewController: UIViewController {
    
    var carplayControl          : UIView?
    var window                  : UIView?
    var homeBtn                 : UIImageView?
    var springboardNavVC        : SPNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carplayControl = UIView(frame: CGRect(x: 0, y: 0, w: D.CARPLAY.WIDTH, h: D.SCREEN_HEIGHT))
        carplayControl?.backgroundColor = UIColor.blackColor()
        view.addSubview(carplayControl!)
        
        homeBtn = UIImageView(frame: CGRect(x: (D.CARPLAY.WIDTH - D.CARPLAY.BTN_WIDTH) / 2, y: D.SCREEN_HEIGHT - D.CARPLAY.BTN_WIDTH - D.SPACING.REGULAR, w: D.CARPLAY.BTN_WIDTH, h: D.CARPLAY.BTN_WIDTH))
        homeBtn?.image = UIImage(named: "carplayHome")
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
        springboardVC.view.frame = (window?.bounds)!
        window!.addSubview(springboardNavVC!.view)
        addAsChildViewController(springboardNavVC!, toView: window!)
        springboardNavVC!.didMoveToParentViewController(self)
    }
    
}
