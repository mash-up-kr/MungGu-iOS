//
//  NetworkErrorPopUpShowable.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 14/09/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

protocol NetworkErrorPopUpShowable: class {
    func showNetworkErrorAlert(okayAction: ((UIAlertAction) -> Void)?)
}

extension NetworkErrorPopUpShowable {

    func showNetworkErrorAlert(okayAction: ((UIAlertAction) -> Void)?) {
        if let topController = UIApplication.topViewController() {
            topController.showAlert(title: "Network Error", message: "통신이 원활 하지 않습니다. 잠시 후, 다시 시도 부탁 드립니다.", preferredStyle: .alert, needOkay: false, okayAction: okayAction)
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
