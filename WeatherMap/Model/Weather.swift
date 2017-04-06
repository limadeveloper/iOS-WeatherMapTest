//
//  Weather.swift
//  WeatherMap
//
//  Created by John Lima on 06/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation
import OpenWeatherMapAPIConsumer

struct Weather {

    fileprivate let weatherAPI = OpenWeatherMapAPI(apiKey: API.key, forType: OpenWeatherMapType.Current)
    
    init() {}
}

extension Weather {
    
    struct API {
        fileprivate static let key = "4828e99077d6198e6fd9e3c9bba49655"
    }
}

extension Weather {
    
    func performWeatherRequest(temperatureUnit: VisibleType.Degree, latitude: Double, longitude: Double, completion: ((ResponseOpenWeatherMapProtocol?, String?) -> ())?) {
        
        var unit: TemperatureFormat = .Celsius
        
        switch temperatureUnit {
            case .fahrenheit: unit = .Fahrenheit
            case .kelvin: unit = .Kelvin
            default: unit = .Celsius
        }
        
        weatherAPI.setTemperatureUnit(unit: unit)
        weatherAPI.weather(byLatitude: latitude, andLongitude: longitude)
        
        weatherAPI.performWeatherRequest { (data, response, error) in
            guard error == nil, let data = data else { completion?(nil, error?.localizedDescription); return }
            do {
                let responseWeatherApi = try CurrentResponseOpenWeatherMap(data: data)
                completion?(responseWeatherApi, nil)
            }catch {
                completion?(nil, error.localizedDescription)
            }
        }
    }
}
