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
    
    // MARK: - Stucks
    
    struct Section {
        var title: String
        var items: [Item]
    }
    
    struct Item {
        var title: String
        var subtitle: String
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
        
    }
}
