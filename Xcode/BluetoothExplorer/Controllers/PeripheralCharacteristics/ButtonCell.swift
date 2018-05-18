//
//  ButtonCell.swift
//  BluetoothExplorer
//
//  Created by Jorge Loc Rubio on 5/17/18.
//  Copyright © 2018 PureSwift. All rights reserved.
//

import UIKit

class ButtontCell: UITableViewCell {
    @IBOutlet weak var button : UILabel!
    
    func configureCell(withTitle title:String) {
        button.text = title
    }
}
