//
//  TextFieldAccessoryView.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 08/09/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class TextFieldAccessoryView: UIView {

    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInitializer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInitializer()
    }

    func commonInitializer() {
        guard let view = Bundle.main.loadNibNamed("TextFieldAccessoryView", owner: self, options: nil)?.first as? UIView else {
            preconditionFailure("Couldn't load nib")
        }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
    }

    func didChangeAnswer(_ text: String?) {
        answerLabel.text = text
    }
}
