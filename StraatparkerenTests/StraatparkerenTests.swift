//
//  StraatparkerenTests.swift
//  StraatparkerenTests
//
//  Created by Rick van 't Hof on 31/05/16.
//  Copyright © 2016 Rick van 't Hof. All rights reserved.
//

import XCTest
@testable import Straatparkeren

class StraatparkerenTests: XCTestCase {
    
    var mapsVC              : MapsOverviewController!
    var interfaceModeCntrl  : InterfaceModeController!
    var themeCntrl          : ThemeController!
    var defaults            : DefaultsController!
    var locationCntrl       : LocationDependentController!
    
    override func setUp() {
        super.setUp()
        mapsVC = MapsOverviewController()
        interfaceModeCntrl = InterfaceModeController.sharedInstance
        themeCntrl = ThemeController.sharedInstance
        defaults = DefaultsController.sharedInstance
        locationCntrl = LocationDependentController.sharedInstance
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInterfaceModeNotification() {
        
        let expectation = expectationWithDescription("Expect maximal mode to be set")
        
        // preparation
        class MapsOverviewMock : MapsOverviewController {
            
            var innerExpectation : XCTestExpectation?
            
            override private func viewWillAppear(animated: Bool) {
            }
            
            override func setMaximalMode() {
                innerExpectation!.fulfill()
                
                //Also check to see if current mode is maximal mode
                XCTAssert(DefaultsController.sharedInstance.getInterfaceMode() == .MAXIMAL)
                
            }
        }
        
        // Make sure current state gets restored after test.
        // Turn on and off the safetymode to make sure all calls will arrive
        let safetyMode = defaults.isInSafetyMode()
        defaults.setSafetyMode(true)
        interfaceModeCntrl.start()
        interfaceModeCntrl.setMode(.MINIMAL)
        defaults.setSafetyMode(false)
        interfaceModeCntrl.stop()
        let mapsOverviewMock = MapsOverviewMock()
        let navigationController = UINavigationController(rootViewController: mapsOverviewMock)
        navigationController.viewControllers.first?.view
        
        mapsOverviewMock.innerExpectation = expectation
        
        // notify
        defaults.setSafetyMode(true)
        interfaceModeCntrl.start()
        interfaceModeCntrl.setMode(.MAXIMAL)
        
        defaults.setSafetyMode(safetyMode)
        
        waitForExpectationsWithTimeout(5.0) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout failed with error: \(error)")
            }
        }
        
    }
    
    func testThemeNotification() {
        
        let expectation = expectationWithDescription("Expect day mode to be set")
        
        // preparation
        class MapsOverviewMock : MapsOverviewController {
            
            var innerExpectation : XCTestExpectation?
            
            override func setDayMode() {
                innerExpectation!.fulfill()
                
                //Also check to see if current theme is in fact day mode
                XCTAssert(DefaultsController.sharedInstance.getCurrentTheme() == .DAY)
            }
        }
        
        
        let mapsOverviewMock = MapsOverviewMock()
        let navigationController = UINavigationController(rootViewController: mapsOverviewMock)
        navigationController.viewControllers.first?.view
        
        mapsOverviewMock.innerExpectation = expectation
        
        // notify
        let currentTheme = defaults.getCurrentTheme()
        themeCntrl.setTheme(.DAY)
        
        
        waitForExpectationsWithTimeout(5.0) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout failed with error: \(error)")
            }
            // restore setting
            self.defaults.setTheme(currentTheme)
        }
        
    }
    
    // Test if location notification arrive at listeners
    func testLocationNotification() {
        
        let expectation = expectationWithDescription("Expect notification on region enter")
        
        // preparation
        class CarPlayMock : CarplayWindowViewController {
            static let notification = "test"
            static let type : MONITORING_TYPE = .REGION
            
            var innerExpectation : XCTestExpectation?
            
            override func displayNotification(notification: NSNotification){
                innerExpectation?.fulfill()
                
                let userInfo : NSDictionary = notification.userInfo!
                
                //assert if title and type are correctly transferred
                if let title = userInfo["value"] as? String{
                    XCTAssert(title == CarPlayMock.notification)
                }
                if let type = userInfo["type"] as? MONITORING_TYPE{
                    XCTAssert(type == CarPlayMock.type)
                }
                
            }
        }
        
        
        let carPlayMock = CarPlayMock()
        let navigationController = UINavigationController(rootViewController: carPlayMock)
        navigationController.viewControllers.first?.view
        
        carPlayMock.innerExpectation = expectation
        
        // notify
        locationCntrl.sentLocationTrigger(CarPlayMock.type, value: CarPlayMock.notification)
        
        
        waitForExpectationsWithTimeout(5.0) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout failed with error: \(error)")
            }
        }
        
    }
    
    
}
