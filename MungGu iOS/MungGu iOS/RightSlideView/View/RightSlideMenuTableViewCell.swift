//
//  TableViewCell.swift
//  MungGu iOS
//
//  Created by Cloud on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation
import UIKit

class RightSlideMenuTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var setStar: UIButton!

    // MARK: - Handlers
    @IBAction private func setStar(_ sender: UIButton) {
        setStar.isSelected.toggle()
    }
}
