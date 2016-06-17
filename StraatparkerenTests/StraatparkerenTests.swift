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
    
    override func setUp() {
        super.setUp()
        mapsVC = MapsOverviewController()
        interfaceModeCntrl = InterfaceModeController.sharedInstance
        themeCntrl = ThemeController.sharedInstance
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
            
            override func setMaximalMode() {
                innerExpectation!.fulfill()
                
                //Also check to see if current mode is maximal mode
                XCTAssert(InterfaceModeController.sharedInstance.currentMode() == .MAXIMAL)

            }
        }
        
        
        let mapsOverviewMock = MapsOverviewMock()
        let navigationController = UINavigationController(rootViewController: mapsOverviewMock)
        navigationController.viewControllers.first?.view
        
        mapsOverviewMock.innerExpectation = expectation
        
        // notify
        interfaceModeCntrl.setMode(.MAXIMAL)
        
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
        themeCntrl.setTheme(.DAY)
        
        
        waitForExpectationsWithTimeout(5.0) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout failed with error: \(error)")
            }
        }
        
    }

    
}
