//
//  FileTableViewCell.swift
//  MungGu iOS
//
//  Created by juhee on 13/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class FileTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedFlagView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.backgroundColor = selected ? .white : .backgroundWhite
        selectedFlagView.backgroundColor = selected ? .tomatoRed : .clear
    }

}
