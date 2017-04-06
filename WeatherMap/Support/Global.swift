//
//  Global.swift
//  WeatherMap
//
//  Created by John Lima on 05/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    static let `default` = #colorLiteral(red: 0, green: 0.5843137255, blue: 0.3254901961, alpha: 1)
    static let gray = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
}

struct Images {
    static let list = #imageLiteral(resourceName: "List-50")
    static let map1 = #imageLiteral(resourceName: "Map1-50")
    static let map2 = #imageLiteral(resourceName: "Map2-50")
}

struct Texts {
    
    struct Buttons {
        static let ok = "Ok"
        static let no = "No"
        static let cancel = "Cancel"
    }
    
    struct Titles {
        static let defaultNav = "LuizaLabs Challenge"
        static let alert = "Alert"
    }
    
    struct Messages {
        static let emptyData = "No data"
        static let enableLocation = "To use location services, you need to enable it on settings."
    }
}

struct Fonts {
    
    enum Size: CGFloat {
        case verySmall = 12
        case small = 14
        case normal = 15
        case `default` = 17
        case medium = 20
        case bigger = 26
    }
    
    static func getDefault(withSize: Size = .default) -> UIFont {
        return .systemFont(ofSize: withSize.rawValue)
    }
    
    static func getDefaultBold(withSize: Size = .default) -> UIFont {
        return .boldSystemFont(ofSize: withSize.rawValue)
    }
}

struct VisibleType {
    
    enum Degree: String {
        case celsius = "ºC"
        case fahrenheit = "ºF"
        case kelvin = "K"
    }
    
    enum VisibleMode {
        case list
        case map
    }
}

struct Alert {
    
    static func enableLocation(target: AnyObject) {
        
        let no = UIAlertAction(title: Texts.Buttons.no, style: .destructive, handler: nil)
        
        let yes = UIAlertAction(title: Texts.Buttons.ok, style: .default) { action in
            guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        let alert = UIAlertController(title: Texts.Titles.alert, message: Texts.Messages.enableLocation, preferredStyle: .alert)
        
        alert.addAction(no)
        alert.addAction(yes)
        
        target.present(alert, animated: true, completion: nil)
    }
}
