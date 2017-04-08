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
    fileprivate let rowHeightDefault: CGFloat = 144
    fileprivate let rowHeightEmpty: CGFloat = 50
    fileprivate var tableData: [Weather]?
    fileprivate var amountResults = 50
    fileprivate var degreeButton: UIBarButtonItem!
    fileprivate var visibleModeButton: UIBarButtonItem!
    fileprivate var degreeTypeSelected: VisibleType.Degree = .celsius
    fileprivate var visibleModeSelected: VisibleType.VisibleMode = .list
    fileprivate var weather = Weather()
    fileprivate var weatherError: String?
    fileprivate let locationManager = CLLocationManager()
    fileprivate var locationObject: CLLocation?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocation()
        
        updateUI()
        
        showTableView()
    }
    
    // MARK: - Actions
    fileprivate func updateUI() {
        
        let footer = UIView(frame: .zero)
        
        tableView.tableFooterView = footer
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = (tableData ?? []).count > 0
        tableView.separatorStyle = .none
        
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

// MARK: - TableView DataSource and TableView Delegate
extension HomeController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableData = tableData else { return 1 }
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tableData = tableData, tableData.count > 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: emptyCell, for: indexPath)
            cell.textLabel?.text = weatherError ?? NSLocalizedString(Texts.Messages.emptyData, comment: "")
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = Colors.gray
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultCell, for: indexPath) as! HomeDefaultTableViewCell
        cell.setup(data: tableData[indexPath.row], temperatureUnit: degreeTypeSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let data = tableData else { return rowHeightEmpty }
        return data.count > 0 ? rowHeightDefault : rowHeightEmpty
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Location
extension HomeController: CLLocationManagerDelegate {

    fileprivate func setupLocation() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied:
            Alert.enableLocation(target: self)
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegionMake(userLocation, span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        weather.fetchWeatherForNearbyLocations(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, amountResults: amountResults) { (weatherData, error) in
            
            DispatchQueue.main.async { [weak self] in
                
                guard error == nil, let data = weatherData else {
                    self?.weatherError = error;
                    self?.tableView.reloadData()
                    return
                }
                
                if self?.tableData == nil {
                    self?.tableData = []
                }
                
                self?.tableData = data
                self?.tableView.reloadData()
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                manager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error: \(error.localizedDescription)")
    }
}
