//
//  CommonNavigationView.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 27/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class CommonNavigationView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInitializer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInitializer()
    }

    func commonInitializer() {
        guard let view = Bundle.main.loadNibNamed("CommonNavigationView", owner: self, options: nil)?.first as? UIView else {
            preconditionFailure("Couldn't load nib")
        }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
    }

    func configure(title: String = "", leftButtonImage: UIImage?, rightButtonImage: UIImage?, rightButtonTitle: String = "") {

        titleLabel.text = title
        leftButton.setImage(leftButtonImage, for: .normal)
        rightButton.setImage(rightButtonImage, for: .normal)
        rightButton.setTitle(rightButtonTitle, for: .normal)
    }
}
