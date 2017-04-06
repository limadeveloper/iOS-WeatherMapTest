//
//  HomeController.swift
//  WeatherMap
//
//  Created by John Lima on 05/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var mapView: MKMapView!
    
    fileprivate let defaultCell = "cell"
    fileprivate let emptyCell = "emptyCell"
    fileprivate var tableData: [Any]?
    fileprivate var degreeButton: UIBarButtonItem!
    fileprivate var visibleModeButton: UIBarButtonItem!
    fileprivate var degreeTypeSelected: VisibleType.Degree = .celsius
    fileprivate var visibleModeSelected: VisibleType.VisibleMode = .list
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        updateUI()
        
        showTableView()
    }
    
    // MARK: - Actions
    fileprivate func getData() {
        
        print("getting data...")
    }
    
    fileprivate func updateUI() {
        
        let footer = UIView(frame: .zero)
        
        tableView.tableFooterView = footer
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = (tableData ?? []).count > 0
        
        navigationItem.title = NSLocalizedString(Texts.Titles.defaultNav, comment: "").uppercased()
        
        setupNavigationButtons()
        
        tableView.reloadData()
    }
    
    fileprivate func setupNavigationButtons() {
        
        degreeButton = UIBarButtonItem(title: degreeTypeSelected.rawValue.uppercased(), style: .plain, target: self, action: #selector(degreeButtonDidClick(sender:)))
        
        var image = UIImage()
        
        switch visibleModeSelected {
            case .map: image = Images.map1
            default: image = Images.list
        }
        
        visibleModeButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(visibleModelButtonDidClick(sender:)))
        
        navigationItem.rightBarButtonItems = [visibleModeButton, degreeButton]
    }
    
    fileprivate func showMapView() {
    
        tableView.isHidden = true
        mapView.isHidden = false
    }
    
    fileprivate func showTableView() {
    
        tableView.isHidden = false
        mapView.isHidden = true
    }
    
    dynamic fileprivate func degreeButtonDidClick(sender: UIBarButtonItem) {
        
        switch degreeTypeSelected {
            case .fahrenheit:
                degreeTypeSelected = .celsius
            default:
                degreeTypeSelected = .fahrenheit
        }
        
        getData()
        updateUI()
    }
    
    dynamic fileprivate func visibleModelButtonDidClick(sender: UIBarButtonItem) {
        
        switch visibleModeSelected {
            case .map:
                visibleModeSelected = .list
                showTableView()
            default:
                visibleModeSelected = .map
                showMapView()
        }
        
        updateUI()
    }
}

// MARK: - TableView DataSource and TableView DataSource
extension HomeController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableData = tableData else { return 1 }
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        guard let tableData = tableData, tableData.count > 0 else {
            cell = tableView.dequeueReusableCell(withIdentifier: emptyCell, for: indexPath)
            cell.textLabel?.text = NSLocalizedString(Texts.Messages.emptyData, comment: "")
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = Colors.gray
            return cell
        }
        
        cell = tableView.dequeueReusableCell(withIdentifier: defaultCell, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
