//
//  ElementCell.swift
//  BluetoothExplorer
//
//  Created by Jorge Loc Rubio on 5/17/18.
//  Copyright © 2018 PureSwift. All rights reserved.
//

import UIKit

class ElementCell: UITableViewCell {
    @IBOutlet weak var element : UILabel!
    
    func configureCell(withTitle title:String) {
        element.text = title
    }

}
