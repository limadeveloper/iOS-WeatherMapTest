//
//  WeatherCoordinate.swift
//  WeatherMap
//
//  Created by John Lima on 08/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation
import Gloss

struct WeatherCoordinate: Decodable {
    
    var latitude: Double?
    var longitude: Double?
    
    init?(json: JSON) {
        
        guard let latitude: Double = Keys.latitude <~~ json else { return }
        guard let longitude: Double = Keys.longitude <~~ json else { return }
        
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension WeatherCoordinate {
    
    struct Keys {
        static let latitude = "lat"
        static let longitude = "lon"
    }
}
