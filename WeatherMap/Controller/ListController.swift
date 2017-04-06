//
//  ListController.swift
//  WeatherMap
//
//  Created by John Lima on 05/04/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

class ListController: UIViewController {

    // MARK: - Properties
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate let defaultCell = "cell"
    fileprivate let emptyCell = "emptyCell"
    fileprivate var tableData: [Any]?
    fileprivate var degreeButton: UIBarButtonItem!
    fileprivate var styleButton: UIBarButtonItem!
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    // MARK: - Actions
    fileprivate func updateUI() {
        
        let footer = UIView(frame: .zero)
        
        tableView.tableFooterView = footer
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = (tableData ?? []).count > 0
    }
    
    fileprivate func setupStyleButton() {
    
    }
    
    fileprivate func setupDegreeButton() {
        
    }
}

// MARK: - TableView DataSource and TableView DataSource
extension ListController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableData = tableData else { return 1 }
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        guard let tableData = tableData, tableData.count > 0 else {
            cell = tableView.dequeueReusableCell(withIdentifier: emptyCell, for: indexPath)
            cell.textLabel?.text = Texts.Messages.emptyData
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = Colors.default
            return cell
        }
        
        cell = tableView.dequeueReusableCell(withIdentifier: defaultCell, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
