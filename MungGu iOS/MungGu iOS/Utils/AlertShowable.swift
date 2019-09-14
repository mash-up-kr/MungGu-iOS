//
//  AlertShowable.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 13/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

protocol AlertShowable: class {
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style, needOkay: Bool, okayAction: ((UIAlertAction) -> Void)?)
}

extension AlertShowable where Self: UIViewController {
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style, needOkay: Bool, okayAction: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

        let cancelTitle = needOkay ? "취소" : "확인"
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: needOkay ? nil : okayAction)
        alert.addAction(cancelAction)

        if needOkay {
            let okayAction = UIAlertAction(title: "확인", style: .default, handler: okayAction)
            alert.addAction(okayAction)
        }

        present(alert, animated: true, completion: nil)
    }
}

extension UIViewController: AlertShowable { }
