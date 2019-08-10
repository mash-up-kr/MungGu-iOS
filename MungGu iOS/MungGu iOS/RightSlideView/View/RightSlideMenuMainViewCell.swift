//
//  TableViewCell.swift
//  MungGu iOS
//
//  Created by Cloud on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation
import UIKit

class RightSlideMenuMainViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var importantButton: UIButton!

    // MARK: - Handlers
    @IBAction private func setStar(_ sender: UIButton) {
        importantButton.isSelected.toggle()
    }
}
