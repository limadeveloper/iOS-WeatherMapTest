//
//  DefaultNavigationController.swift
//  WeatherMap
//
//  Created by John Lima on 05/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

class DefaultNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        updateUI()
    }
    
    fileprivate func updateUI() {
        navigationBar.tintColor = Colors.default
        navigationBar.titleTextAttributes = [NSFontAttributeName: Fonts.getDefaultBold(withSize: .normal)]
    }
}
