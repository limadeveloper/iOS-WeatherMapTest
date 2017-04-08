//
//  WeatherWind.swift
//  WeatherMap
//
//  Created by John Lima on 08/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation
import Gloss

struct WeatherWind: Decodable {
    
    var deg: Int?
    var speed: Double?
    
    init?(json: JSON) {
        self.deg = Keys.deg <~~ json
        self.speed = Keys.speed <~~ json
    }
}

extension WeatherWind {
    
    struct Keys {
        static let deg = "deg"
        static let speed = "speed"
    }
}
