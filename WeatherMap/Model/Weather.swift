//
//  Weather.swift
//  WeatherMap
//
//  Created by John Lima on 06/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation
import Gloss

struct Weather {
    
    init() {}
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
    }
}

extension Weather {
    
    func fetchWeatherForNearbyLocations(latitude: Double, longitude: Double, amountResults: Int, completion: (([Weather]?, String?) -> ())?) {
        
        var result = [JSON]()
        let session = URLSession.shared
        let stringURL = "\(Urls.weatherMap)?APPID=\(API.key)&lat=\(latitude)&lon=\(longitude)&cnt=\(amountResults)"
        let requestURL = URLRequest(url: URL(string: stringURL)!)
        
        let request = session.dataTask(with: requestURL) { (data, response, error) in
            
            do {
            
                guard error == nil, let data = data else { completion?(nil, error?.localizedDescription); return }
                guard let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSON, let list = jsonData[Keys.list] as? JSON, list.count > 0 else { completion?(nil, Texts.Messages.emptyData); return }
                
                for item in list {
                    result.append(item)
                }
                
            }catch {
                completion?(nil, error.localizedDescription)
            }
        }
        
        request.resume()
    }
}
