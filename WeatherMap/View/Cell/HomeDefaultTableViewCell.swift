//
//  HomeDefaultTableViewCell.swift
//  WeatherMap
//
//  Created by John Lima on 06/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import OpenWeatherMapAPIConsumer

class HomeDefaultTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var cityLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var temperatureLabel: UILabel!
    @IBOutlet fileprivate weak var temperatureMaxAndMinLabel: UILabel!
    @IBOutlet fileprivate weak var picture: UIImageView!
    
    fileprivate var data: ResponseOpenWeatherMapProtocol? {
        didSet {
            
            guard let data = data else { return }
            
            print("city name: \(data.getCityName())")
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

    func setup(data: ResponseOpenWeatherMapProtocol) {
        self.data = data
    }
}
