//
//  WeatherMapUITests.swift
//  WeatherMapUITests
//
//  Created by John Lima on 10/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import XCTest

class WeatherMapUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        let app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetScreenshots() {
    
        let app = XCUIApplication()
        let navigationBar = app.navigationBars.element(boundBy: 0)
        
        navigationBar.buttons.element(boundBy: 0).tap()
        
        navigationBar.buttons.element(boundBy: 1).tap()
        sleep(5)
        // Map
        
        navigationBar.buttons.element(boundBy: 0).tap()
        navigationBar.buttons.element(boundBy: 1).tap()
        sleep(5)
        // List
    }
}
