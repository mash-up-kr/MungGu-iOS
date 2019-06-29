//
//  NamedColor.swift
//  MungGu iOS
//
//  Created by juhee on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
extension UIColor {
    static var blush: UIColor = namedColor(name: "blush")
    static var lightPeach: UIColor = namedColor(name: "lightPeach")

    static func namedColor(name: String) -> UIColor {
        guard let color = UIColor(named: name) else {
            preconditionFailure("invalid uiColor named: \(name)")
        }
        return color
    }
}
