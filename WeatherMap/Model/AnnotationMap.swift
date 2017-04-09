//
//  AnnotationMap.swift
//  WeatherMap
//
//  Created by John Lima on 08/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation
import MapKit

class AnnotationMap: NSObject, MKAnnotation {

    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double, title: String? = nil, subtitle: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.subtitle = subtitle
    }
}

extension AnnotationMap {

    static func getAnnotations(fromWeatherData: [Weather]?, temperatureType: VisibleType.Degree?) -> [AnnotationMap]? {
        
        guard let weatherData = fromWeatherData, weatherData.count > 0 else { return nil }
        guard let temperatureType = temperatureType else { return nil }
        
        var annotations: [AnnotationMap]?
        
        for item in weatherData {
        
            guard let name = item.name else { continue }
            guard let temp = item.main?.temperature, let emojiId = item.weather?.first?.id else { continue }
            guard let latitude = item.coordinates?.latitude, let longitude = item.coordinates?.longitude else { continue }
            
            let temperature = item.toUnit(value: temp, temperatureType: temperatureType)
            let emoji = item.determineWeatherConditionSymbol(fromWeathercode: emojiId)
            
            let annotation = AnnotationMap(latitude: latitude, longitude: longitude, title: name, subtitle: "\(emoji) \(temperature)")
            
            if annotations == nil {
                annotations = []
            }
            
            annotations?.append(annotation)
        }
        
        guard let data = annotations, data.count > 0 else { return nil }
        
        return data
    }
}
