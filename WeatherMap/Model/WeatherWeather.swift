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
    var icon: String?
    var id: Int?
    var main: String?
    var urlImage: URL?
    
    init() {}
    
    init?(json: JSON) {
        
        self.description = Keys.description <~~ json
        self.icon = Keys.icon <~~ json
        self.id = Keys.id <~~ json
        self.main = Keys.main <~~ json
        
        guard let icon = self.icon else { return }
        self.urlImage = URL(string: "http://openweathermap.org/img/w/\(icon).png")
    }
}

extension WeatherWeather {
    
    struct Keys {
        static let description = "description"
        static let icon = "icon"
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
