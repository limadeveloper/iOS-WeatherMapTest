//
//  WeatherCloud.swift
//  WeatherMap
//
//  Created by John Lima on 08/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation
import Gloss

struct WeatherCloud: Decodable {

    var all: Int?
    
    init?(json: JSON) {
        self.all = Keys.all <~~ json
    }
}

extension WeatherCloud {
    
    struct Keys {
        static let all = "all"
    }
}
