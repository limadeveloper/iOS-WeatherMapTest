//
//  WeatherMapTests.swift
//  WeatherMapTests
//
//  Created by John Lima on 10/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import XCTest
@testable import WeatherMap

class WeatherMapTests: XCTestCase {
    
    fileprivate let weather = Weather()
    fileprivate let weatherCode = 802
    
    struct Coordinate {
        struct Cupertino {
            static let latitude: Double = 37.323
            static let longitude: Double = -122.0322
        }
    }
    
    struct Temperature {
        static let celsius: Double = 0
        static let fahrenheit: Double = 32
        static let kelvin: Double = 273.15
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testFetchWeatherData() {
        
        let expect = expectation(description: "weather")
        
        weather.fetchWeatherForNearbyLocations(latitude: Coordinate.Cupertino.latitude, longitude: Coordinate.Cupertino.longitude) { (data, error) in
            
            XCTAssert(error == nil && (data ?? []).count > 0)
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testWeatherGetImages() {
        let icon = weather.determineWeatherConditionSymbol(fromWeathercode: weatherCode)
        XCTAssert(!icon.isEmpty)
    }
    
    func testTemperature() {
        
        let kelvinToCelsius = weather.toUnit(value: Temperature.kelvin, temperatureType: .celsius)
        let kelvinToFahrenheit = weather.toUnit(value: Temperature.kelvin, temperatureType: .fahrenheit)
        
        XCTAssert(kelvinToCelsius == "\(Int(Temperature.celsius))\(VisibleType.Degree.celsius.rawValue)")
        XCTAssert(kelvinToFahrenheit == "\(Int(Temperature.fahrenheit))\(VisibleType.Degree.fahrenheit.rawValue)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            self.weather.fetchWeatherForNearbyLocations(latitude: Coordinate.Cupertino.latitude, longitude: Coordinate.Cupertino.longitude, completion: nil)
            let _ = self.weather.determineWeatherConditionSymbol(fromWeathercode: self.weatherCode)
            let _ = self.weather.toUnit(value: Temperature.kelvin, temperatureType: .celsius)
        }
    }
    
}
