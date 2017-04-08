//
//  WeatherWeather.swift
//  WeatherMap
//
//  Created by John Lima on 08/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation
import Gloss

struct WeatherWeather: Decodable {
    
    var description: String?
    var emoji: String?
    var id: Int?
    var main: String?
    
    init() {}
    
    init?(json: JSON) {
        self.description = Keys.description <~~ json
        self.emoji = Keys.emoji <~~ json
        self.id = Keys.id <~~ json
        self.main = Keys.main <~~ json
    }
}

extension WeatherWeather {
    
    struct Keys {
        static let description = "description"
        static let emoji = "icon"
        static let id = "id"
        static let main = "main"
    }
}

extension WeatherWeather {

    func getObjects(fromArray: [JSON]) -> [WeatherWeather]? {
        
        guard fromArray.count > 0 else { return nil }
        
        var objects = [WeatherWeather]()
        
        for json in fromArray {
            guard let obj = WeatherWeather(json: json) else { continue }
            objects.append(obj)
        }
        
        guard objects.count > 0 else { return nil }
        
        return objects
    }
}
