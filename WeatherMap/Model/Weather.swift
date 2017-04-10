//
//  Weather.swift
//  WeatherMap
//
//  Created by John Lima on 06/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation
import Gloss
import MapKit

struct Weather: Decodable {
    
    var clouds: WeatherCloud?
    var coordinates: WeatherCoordinate?
    var id: Int?
    var main: WeatherMain?
    var name: String?
    var rain: String?
    var snow: String?
    var weather: [WeatherWeather]?
    var wind: WeatherWind?
    
    init() {}
    
    init?(json: JSON) {
        self.clouds = Keys.clouds <~~ json
        self.coordinates = Keys.coordinates <~~ json
        self.id = Keys.id <~~ json
        self.main = Keys.main <~~ json
        self.name = Keys.name <~~ json
        self.weather = Keys.weather <~~ json
        self.wind = Keys.wind <~~ json
    }
}

extension Weather {
    
    struct API {
        fileprivate static let key = "4828e99077d6198e6fd9e3c9bba49655"
    }
    
    struct Urls {
        
        fileprivate static let weatherMap = "http://api.openweathermap.org/data/2.5/find"
    }
    
    struct Keys {
        static let list = "list"
        static let clouds = "clouds"
        static let coordinates = "coord"
        static let id = "id"
        static let main = "main"
        static let name = "name"
        static let rain = "rain"
        static let snow = "snow"
        static let weather = "weather"
        static let wind = "wind"
    }
}

extension Weather {
    
    func fetchWeatherForNearbyLocations(latitude: Double, longitude: Double, amountResults: Int = 0, completion: (([Weather]?, String?) -> ())?) {
        
        var result = [Weather]()
        let session = URLSession.shared
        let language = Locale.current.languageCode ?? "en"
        var stringURL = "\(Urls.weatherMap)?APPID=\(API.key)&lat=\(latitude)&lon=\(longitude)&cnt=\(amountResults)&lang=\(language)"
        
        if amountResults == 0 {
            stringURL = "\(Urls.weatherMap)?APPID=\(API.key)&lat=\(latitude)&lon=\(longitude)&lang=\(language)"
        }
        
        let requestURL = URLRequest(url: URL(string: stringURL)!)
        
        let request = session.dataTask(with: requestURL) { (data, response, error) in
            
            do {
                
                guard error == nil, let data = data else { completion?(nil, error?.localizedDescription); return }
                guard let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSON, let list = jsonData[Keys.list] as? [JSON], list.count > 0 else { completion?(nil, Texts.Messages.emptyData); return }
                
                print("json: \(jsonData as NSDictionary)")
                
                for i in 0 ..< list.count {
                    
                    guard let object = Weather(json: list[i]) else { continue }
                    result.append(object)
                    
                    if i == list.count-1 {
                        completion?(result, nil)
                    }
                }
                
            }catch {
                completion?(nil, error.localizedDescription)
            }
        }
        
        request.resume()
    }
}

extension Weather {
    
    func determineWeatherConditionSymbol(fromWeathercode: Int) -> String {
        
        switch fromWeathercode {
        case let x where (x >= 200 && x <= 202) || (x >= 230 && x <= 232): return "⛈"
        case let x where x >= 210 && x <= 211: return "🌩"
        case let x where x >= 212 && x <= 221: return "⚡️"
        case let x where x >= 300 && x <= 321: return "🌦"
        case let x where x >= 500 && x <= 531: return "🌧"
        case let x where x >= 600 && x <= 622: return "🌨"
        case let x where x >= 701 && x <= 771: return "🌫"
        case let x where x == 781 || x >= 958: return "🌪"
        case let x where x == 800:
            
            // Simulate day/night mode for clear skies condition -> sunset @ 18:00
            let currentDateFormatter = DateFormatter()
            currentDateFormatter.dateFormat = "ddMMyyyy"
            let currentDateString = currentDateFormatter.string(from: Date())
            
            let zeroHourDateFormatter = DateFormatter()
            zeroHourDateFormatter.dateFormat = "ddMMyyyyHHmmss"
            let zeroHourDate = zeroHourDateFormatter.date(from: (currentDateString + "000000"))!
            
            guard Date().timeIntervalSince(zeroHourDate) > 64800 else { return "☀️" }
            return "🌃"
            
        case let x where x == 801: return "🌤"
        case let x where x == 802: return "⛅️"
        case let x where x == 803: return "🌥"
        case let x where x == 804: return "☁️"
        case let x where x >= 952 && x <= 958: return "💨"
        default: return "☀️"
        }
    }
    
    func toUnit(value: Double, temperatureType: VisibleType.Degree) -> String {
        switch temperatureType {
        case .celsius: return "\(String(format:"%.0f", value - 273.15))\(temperatureType.rawValue)"
        case .fahrenheit: return "\(String(format:"%.0f", value * (9/5) - 459.67))\(temperatureType.rawValue)"
        case .kelvin: return "\(String(format:"%.0f", value))\(temperatureType.rawValue)"
        }
    }
    
    static func distance(fromLocation: CLLocation, inKilometers: Double, weatherData: [Weather]?) -> [Weather]? {
        let inMeters = inKilometers * 1000
        let filter = weatherData?.filter({ CLLocation(latitude: $0.coordinates?.latitude ?? 0, longitude: $0.coordinates?.longitude ?? 0).distance(from: fromLocation) <= inMeters })
        return filter
    }
}
