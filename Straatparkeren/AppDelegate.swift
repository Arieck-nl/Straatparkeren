//
//  AppDelegate.swift
//  Straatparkeren
//
//  Created by Rick van 't Hof on 09/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var themeCntrl              : ThemeController?
    var interfaceCntrl          : InterfaceModeController?
    var locationDependentCntrl  : LocationDependentController?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let defaults = DefaultsController.sharedInstance
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = CarplayWindowViewController()
        window?.makeKeyAndVisible()
        
        
        // Start interface controllers for monitoring
        themeCntrl = ThemeController.sharedInstance
        if DD.BRIGHTNESS_ON{
            themeCntrl!.start()
        }
        
        interfaceCntrl = InterfaceModeController.sharedInstance
        
        if defaults.isInSafetyMode(){ interfaceCntrl?.start() }
        
        locationDependentCntrl = LocationDependentController.sharedInstance
        let durations = defaults.getETANotificationDurations()
        if durations.count > 0{
            locationDependentCntrl?.setMonitoringForETAsToDestination((defaults.getDestination()?.getCoordinate())!, etas: durations)
        }
        
        
        UIApplication.sharedApplication().statusBarHidden = true
        UIApplication.sharedApplication().idleTimerDisabled = true
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // Reset first time use when terminating app for demo purposes
        DefaultsController.sharedInstance.setFirstTimeUse(false)
    }


}

