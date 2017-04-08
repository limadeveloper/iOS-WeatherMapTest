//
//  WeatherMain.swift
//  WeatherMap
//
//  Created by John Lima on 08/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation
import Gloss

struct WeatherMain: Decodable {
    
    var humidity: Int?
    var pressure: Int?
    var temperature: Double?
    var temperatureMax: Double?
    var temperatureMin: Double?
    
    init?(json: JSON) {
        self.humidity = Keys.humidity <~~ json
        self.pressure = Keys.pressure <~~ json
        self.temperature = Keys.temperature <~~ json
        self.temperatureMax = Keys.temperatureMax <~~ json
        self.temperatureMin = Keys.temperatureMin <~~ json
    }
}

extension WeatherMain {
    
    struct Keys {
        static let humidity = "humidity"
        static let pressure = "pressure"
        static let temperature = "temp"
        static let temperatureMax = "temp_max"
        static let temperatureMin = "temp_min"
    }
}
