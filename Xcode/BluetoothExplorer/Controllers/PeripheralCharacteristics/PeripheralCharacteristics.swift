//
//  PeripheralCharacteristics.swift
//  BluetoothExplorer
//
//  Created by Jorge Loc Rubio on 5/17/18.
//  Copyright © 2018 PureSwift. All rights reserved.
//

import Foundation

import UIKit
import GATT
import Bluetooth

class PeripheralCharacteristicsViewController: UITableViewController {
    
    // MARK: - Enums
    enum cellType {
        case DetailCell
        case ButtonCell
        case ElementCell
    }
    
    // MARK: - Stucks
    
    struct Section {
        var title: String
        var items: [Item]
    }
    
    struct Item {
        var title: String
        var subtitle: String?
        var type: cellType
    }
    
    // MARK: - Outlets
    
    @IBOutlet var navigationItemView: UINavigationItem!
    
    // MARK: - Properties
    
    weak var central: CentralManager?
    var scanData: ScanData?
    var characteristic: CentralManager.Characteristic?
    var sections: [Section] = []
    var descriptors : Section?
    
    static let descriptorWrite = "Client Characteristic Configuration"
    static let descriptorExtended = "Characteristic Extended Properties"
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Configuration
    private func setupUI() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        guard let characteristic = characteristic else {
            return
        }
        
        self.navigationItemView.title = characteristic.uuid.rawValue
        
        descriptors = Section(title: "DESCRIPTORS", items: [])
        getSection(by: characteristic)
        
        let properties = characteristic.properties.map({ (characteristic) -> Item in
            return Item(title: characteristic.name, subtitle: "", type: .ElementCell)
        })
        
        sections.append(descriptors!)
        sections.append(Section(title: "PROPERTIES", items: properties))
    }
    
    private func getSection(by characteristic:CentralManager.Characteristic) {
        let properties = characteristic.formattedProperties
        
        if properties.contains("read") && properties.contains("notify") {
                sections.append(Section(title: "NOTIFY/READ VALUES", items: [Item(title: "Read again", subtitle: nil, type: .ButtonCell)]))
        } else if properties.contains("read") {
            sections.append(Section(title: "READ VALUES", items: [Item(title: "Read again", subtitle: nil, type: .ButtonCell)]))
        } else if properties.contains("notify") {
            sections.append(Section(title: "NOTIFIED VALUES", items: [Item(title: "Read again", subtitle: nil, type: .ButtonCell)]))
        }
        
        if properties.contains("write") {
            sections.append(Section(title: "WRITTEN VALUES", items: [Item(title: "Write new value", subtitle: nil, type: .ButtonCell)]))
            let index = String((descriptors?.items.count)!)
            let item = Item(title: index, subtitle: PeripheralCharacteristicsViewController.descriptorWrite, type: cellType.DetailCell)
            descriptors?.items.append(item)
        }
        
        if properties.contains("extended") {
            let index = String((descriptors?.items.count)!)
            let item = Item(title: index, subtitle: PeripheralCharacteristicsViewController.descriptorExtended, type: cellType.DetailCell)
            descriptors?.items.append(item)
        }
        
    }
    
    fileprivate func configure(cell: DetailCell, item: Item) {
        cell.titleLabel.text = item.title
        cell.subtitleLabel.text = item.subtitle
    }
    
    // MARK: - Private
    
    
}

extension PeripheralCharacteristicsViewController {
    
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
        let identifier = String(describing: item.type)
        let _cell : UITableViewCell
        switch item.type {
        case .ElementCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ElementCell else {
                fatalError("cell should be convertible to ElementCell")
            }
            cell.configureCell(withTitle: item.title)
            _cell = cell
        case .DetailCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? DetailCell else {
                fatalError("cell should be convertible to DetailCell")
            }
            configure(cell: cell, item: item)
            _cell = cell
        case .ButtonCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ButtontCell else {
                fatalError("cell should be convertible to ButtontCell")
            }
            cell.configureCell(withTitle: item.title)
            _cell = cell
        }
        return _cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
