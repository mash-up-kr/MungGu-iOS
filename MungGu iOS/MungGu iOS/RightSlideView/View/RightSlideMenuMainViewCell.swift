//
//  TableViewCell.swift
//  MungGu iOS
//
//  Created by Cloud on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation
import UIKit

final class RightSlideMenuMainViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var importantButton: UIButton!

    weak var delegate: RightSlideMenuMainViewCellDelegate?
    var highlight: Highlight?

    func configure(_ highlight: Highlight) {
        self.highlight = highlight
        wordLabel.text = highlight.content

        if let isImportant = highlight.isImportant {
            importantButton.isSelected = isImportant == 1 ? true : false
        }
    }

    // MARK: - Handlers
    @IBAction private func setStar(_ sender: UIButton) {
        importantButton.isSelected.toggle()
        guard let highlight = highlight else { return }
        delegate?.toggleStar(highlight)
    }
}

protocol RightSlideMenuMainViewCellDelegate: class {
    func toggleStar(_ highlight: Highlight)
}
