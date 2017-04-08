//
//  HomeDefaultTableViewCell.swift
//  WeatherMap
//
//  Created by John Lima on 06/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

class HomeDefaultTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var cityLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var temperatureLabel: UILabel!
    @IBOutlet fileprivate weak var temperatureMaxAndMinLabel: UILabel!
    @IBOutlet fileprivate weak var iconLabel: UILabel!
    @IBOutlet fileprivate weak var backView: UIView!
    
    fileprivate var temperatureUnit: VisibleType.Degree?
    
    fileprivate var data: Weather? {
        didSet {
            
            guard let data = data else { return }
            
            backView.layer.cornerRadius = 7
            backView.setShadow(enable: true)
            
            cityLabel.text = data.name
            descriptionLabel.text = data.weather?.first?.description
            temperatureMaxAndMinLabel.text = nil
            
            if let temperature = data.main?.temperature, let temperatureUnit = temperatureUnit {
                temperatureLabel.text = data.toUnit(value: temperature, temperatureType: temperatureUnit)
            }
            
            if let temperatureMin = data.main?.temperatureMin, let temperatureMax = data.main?.temperatureMax, let temperatureUnit = temperatureUnit {
                let tempMin = data.toUnit(value: temperatureMin, temperatureType: temperatureUnit)
                let tempMax = data.toUnit(value: temperatureMax, temperatureType: temperatureUnit)
                temperatureMaxAndMinLabel.text = "\(tempMin) • \(tempMax)"
            }
            
            guard let weatherCode = data.weather?.first?.id else { return }
            iconLabel.text = data.determineWeatherConditionSymbol(fromWeathercode: weatherCode)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setup(data: Weather, temperatureUnit: VisibleType.Degree) {
        self.temperatureUnit = temperatureUnit
        self.data = data
    }
}
