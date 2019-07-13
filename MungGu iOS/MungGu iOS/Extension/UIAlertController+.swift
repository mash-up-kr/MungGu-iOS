//
//  UIAlertController+.swift
//  MungGu iOS
//
//  Created by juhee on 13/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

extension UIAlertController {

    var defaultConfirmAction: UIAlertAction {
        return UIAlertAction(title: "확인", style: .default, handler: nil)
    }

    convenience init(_ alert: Alerts) {
        #if DEBUG
        if let log = alert.logMessage {
            print("\(#function) \(log)")
        }
        #endif
        self.init(title: alert.title, message: alert.message, preferredStyle: .alert)
    }
}
