//
//  TableViewCell.swift
//  MungGu iOS
//
//  Created by Cloud on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var setStar: UIButton!

    @IBAction func setStar(_ sender: UIButton) {
        setStar.isSelected.toggle()
    }

    func configureCell(_ text: [String]) {
        for tx in text {
            cellLabel.text = tx
        }
        setStar.setImage(#imageLiteral(resourceName: "iconImportantR"), for: .normal)
        setStar.setImage(#imageLiteral(resourceName: "iconImportantG"), for: .selected)
    }
}
