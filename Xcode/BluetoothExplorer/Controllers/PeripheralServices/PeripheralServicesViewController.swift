//
//  PeripheralServicesViewController.swift
//  BluetoothExplorer
//
//  Created by Carlos Duclos on 4/8/18.
//  Copyright © 2018 PureSwift. All rights reserved.
//

import Foundation

import UIKit
import GATT
import Bluetooth

class PeripheralServicesViewController: UITableViewController {
    
    struct Section {
        var title: String
        var items: [Item]
    }
    
    struct Item {
        var title: String
        var subtitle: String
        var selectable: Bool
        var characteristic: CentralManager.Characteristic?
    }
    
    // MARK: - Properties
    
    weak var central: CentralManager?
    var scanData: ScanData?
    var groups: [BluetoothUUID: [CentralManager.Characteristic]] = [:]
    var sections: [Section] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Configuration
    
    private func setupUI() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        if let data = scanData?.advertisementData.manufacturerData {
            let string = String(data: data, encoding: .utf8)
            let infoSection = Section(title: "Device Information", items: [Item(title: "Manufacturer", subtitle: string ?? "Empty", selectable: false, characteristic: nil)])
            sections.append(infoSection)
        }
        
        let serviceSections = groups.map { group -> Section in
            
            let characteristicItems = group.value.map { characteristic in
                Item(title: characteristic.uuid.rawValue, subtitle: characteristic.formattedProperties, selectable: true, characteristic: characteristic)
            }
            
            return Section(title: group.key.rawValue, items: characteristicItems)
        }
        
        sections.append(contentsOf: serviceSections)
    }
    
    fileprivate func configure(cell: DetailCell, item: Item) {
        cell.titleLabel.text = item.title
        cell.subtitleLabel.text = item.subtitle
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCharacteristics" {
            guard let peripheralCharacteristicsController = segue.destination as? PeripheralCharacteristicsViewController else {
                fatalError("destination should be convertible to PeripheralCharacteristicsViewController")
            }
            
            guard let parameters = sender as? (CentralManager.Characteristic, ScanData) else {
                fatalError("sender should be convertible to [BluetoothUUID: CentralManager.Characteristic]")
            }
            
            peripheralCharacteristicsController.central = central
            peripheralCharacteristicsController.characteristic = parameters.0
            peripheralCharacteristicsController.scanData = parameters.1
        }
    }
    
    // MARK: - Private
    
    private func showLoading() {
        DispatchQueue.main.async { HUD.show(.progress) }
    }
    
    private func hideLoading() {
        DispatchQueue.main.async { HUD.hide() }
    }
}

extension PeripheralServicesViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let identifier = String(describing: DetailCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? DetailCell else {
            fatalError("cell should be convertible to DetailCell")
        }
        configure(cell: cell, item: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = sections[indexPath.section].items[indexPath.row]
        guard item.selectable else {
            return
        }
        self.performSegue(withIdentifier: "showCharacteristics", sender: (characteristic: item.characteristic, data: scanData))
        
    }
    
}
