//
//  InterfaceModeController
//  Straatparkeren
//
//  Created by Rick van 't Hof on 28-05-16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import UIKit
import MapKit
import CoreMotion

protocol InterfaceModeProtocol {
    // Divide the interface into three categories, show or hide views according to the categories
    func setMinimalMode()
    func setMediumMode()
    func setMaximalMode()
}

// Define interface modes
public enum I_MODE : Int {
    case MINIMAL, MEDIUM, MAXIMAL
    
    // return notification key for each mode
    var notificationKey : String{
        switch self {
        case .MINIMAL:
            return N.MINIMAL_MODE
        case .MEDIUM:
            return N.MEDIUM_MODE
        case .MAXIMAL:
            return N.MAXIMAL_MODE
        }
    }
}

class InterfaceModeController {
    
    
    // interval for cooldown period
    // if interface has switched, wait till cooldown period is over to be able to switch again
    private let interval : Double = 15.0
    
    private let mediumTrigger : Double = 0.006
    private let maximumTrigger : Double = 0.035
    
    private let peakTrigger = 15
    // Update every X times per second
    private let UpdateFrequency : Double = 15.0
    
    private var stackX = [Double]()
    private var stackY = [Double]()
    private var stackZ = [Double]()
    
    private let motionMgr = CMMotionManager()
    
    private var lowerStarted = false
    private var upperStarted = false
    
    private var startDate : NSDate = NSDate()
    private let mainQueue = NSOperationQueue.mainQueue()
    
    private var peaks : Int = 0
    
    
    // Singleton instance
    static let sharedInstance = InterfaceModeController()
    
    init(){
        motionMgr.deviceMotionUpdateInterval = 1.0 / UpdateFrequency
    }
    
    // start monitoring accelerometer
    func start(){
        if (motionMgr.deviceMotionAvailable) {
            let handler:CMDeviceMotionHandler = {(data: CMDeviceMotion?, error: NSError?) -> Void in
                
                let timeDiff = NSDate().timeIntervalSinceDate(self.startDate)
                
                let accX = (data?.userAcceleration.x)!
                let accY = (data?.userAcceleration.y)!
                let accZ = (data?.userAcceleration.z)!
                
                // for each axis do as follows:
                // remove first item of stack if greater than predefined value
                // add value to stack
                // calculate average of current stack
                if(self.stackX.count >= self.peakTrigger){
                    self.stackX.removeAtIndex(0)
                }
                self.stackX.append(accX)
                
                var totalX : Double = 0
                for item in self.stackX{
                    totalX += item
                }
                let avgX : Double = totalX / Double(self.peakTrigger)
                
                
                if(self.stackY.count >= self.peakTrigger){
                    self.stackY.removeAtIndex(0)
                }
                self.stackY.append(accY)
                
                var totalY : Double = 0
                for item in self.stackY{
                    totalY += item
                }
                let avgY : Double = totalY / Double(self.peakTrigger)
                
                
                if(self.stackZ.count >= self.peakTrigger){
                    self.stackZ.removeAtIndex(0)
                }
                self.stackZ.append(accZ)
                
                var totalZ : Double = 0
                for item in self.stackZ{
                    totalZ += item
                }
                let avgZ : Double = totalZ / Double(self.peakTrigger)
                
                var mode : I_MODE!
                
                // If cooldown period is over, interface switching should be enabled again
                if((timeDiff > self.interval) && (self.stackX.count >= self.peakTrigger)){
                    
//                    print("avgX" + avgX.toString + "avgY" + avgY.toString + "avgZ" + avgZ.toString)
                    
                    // If any of the axis averages exceeds predefined values, trigger interface switching
                    if(abs(avgX) > self.maximumTrigger || abs(avgY) > self.maximumTrigger || abs(avgZ) > self.maximumTrigger){
                        mode = .MINIMAL
                    }
                    else if(abs(avgX) > self.mediumTrigger || abs(avgY) > self.mediumTrigger || abs(avgZ) > self.mediumTrigger){
                        mode = .MEDIUM
                    }
                    else{
                        mode = .MAXIMAL
                    }
                    
                    self.setMode(mode)
                    //reset for new timediff
                    self.startDate = NSDate()

                    
                }
                
            }
            motionMgr.startDeviceMotionUpdatesToQueue(mainQueue, withHandler: handler)
        }
        
    }
    
    func stop(){
        motionMgr.stopDeviceMotionUpdates()
        motionMgr.stopAccelerometerUpdates()
    }
    
    // Notify listening classes of interface change
    func setMode(mode: I_MODE) {
        if(DefaultsController.sharedInstance.getInterfaceMode() != mode){
            
        DefaultsController.sharedInstance.setInterfaceMode(mode)
        
        //callout to all interface mode methods
        NSNotificationCenter.defaultCenter().postNotificationName(mode.notificationKey, object: self)
        }
        
    }
    
    
}

