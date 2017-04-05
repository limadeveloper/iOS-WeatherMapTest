//
//  Extensions.swift
//  WeatherMap
//
//  Created by John Lima on 05/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func startAnimation(duration: TimeInterval = 1.3, delay: Double =  0.05, springWithDamping: CGFloat = 0.8, springVelocity: CGFloat = 0, options: UIViewAnimationOptions = .curveEaseInOut) {
        
        self.reloadData()
        
        let cells = self.visibleCells
        let tableHeight = self.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var delayCounter: Double = 0
        
        for cell in cells {
            UIView.animate(withDuration: duration, delay: delay * delayCounter, usingSpringWithDamping: springWithDamping, initialSpringVelocity: springVelocity, options: options, animations: {
                cell.transform = .identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    func tableViewScrollToTop(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}

extension CGFloat {
    
    static func heightWithConstrainedWidth(string: String, width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
}

extension UIView {
    
    func setShadow(enable: Bool, shadowOffset: CGSize = .zero, shadowColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), shadowRadius: CGFloat = 4, shadowOpacity: Float = 0.25, masksToBounds: Bool = false, clipsToBounds: Bool = false) {
        if enable {
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOpacity = shadowOpacity
            self.layer.masksToBounds = masksToBounds
            self.clipsToBounds = clipsToBounds
        }else {
            self.layer.shadowOffset = .zero
            self.layer.shadowColor = UIColor.clear.cgColor
            self.layer.shadowRadius = 0
            self.layer.shadowOpacity = 0
        }
    }
}

extension Date {
    
    func toString(dateStyle: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        return formatter.string(from: self)
    }
    
    func isToday() -> Bool {
        let sd = self.toString()
        let today = Date().toString()
        return sd == today
    }
}

extension UIAlertController {
    
    /// Use this function to create an alert.
    /// How can I use it?
    ///
    ///     UIAlertController.createAlert(title: "Some Title", message: "Some message", style: .alert, actions: [action1, action2], target: self)
    ///
    /// - Parameters:
    ///   - title: The text that will appear on top of the alert.
    ///   - message: The text that will appear on body of the alert.
    ///   - style: You can choose two style types (Alert and Sheet)
    ///   - actions: Here you can set the actions. Create the actions in your controller and set here.
    ///   - target: The target is the controller where the alert will appear.
    ///   - isPopover: Enable the popover to alert with arrows in iPads.
    ///   - buttonItem: Create the button to use together with popover.
    static func createAlert(title: String? = nil, message: String? = nil, style: UIAlertControllerStyle, actions: [UIAlertAction]?, target: AnyObject?, isPopover: Bool = false, buttonItem: UIBarButtonItem? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        
        if isPopover {
            alert.modalPresentationStyle = .popover
            let popover = alert.popoverPresentationController!
            popover.barButtonItem = buttonItem
            popover.sourceRect = CGRect(x: 0, y: 10, width: 0, height: 0)
            popover.backgroundColor = .white
        }
        
        DispatchQueue.main.async {
            target?.present(alert, animated: true, completion: nil)
        }
    }
}
