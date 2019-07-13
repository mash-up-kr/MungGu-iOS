//
//  HighlightType.swift
//  MungGu iOS
//
//  Created by juhee on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

enum HighlightType {
    case general
    case imortant

    var defaultColor: UIColor {
        switch self {
        case .general:
            return .lightPeach
        case .imortant:
            return .blush
        }
    }

}
