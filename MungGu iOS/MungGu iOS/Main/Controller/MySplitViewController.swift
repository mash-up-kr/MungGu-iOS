//
//  MySplitViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class MySplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = UISplitViewController.DisplayMode.allVisible

        guard let leftNavController = viewControllers.first as? UINavigationController,
            let masterViewController = leftNavController.topViewController as? MasterViewController,
            let viewController = viewControllers.last as? UINavigationController,
            let detailViewController = viewController.viewControllers.last as? TestViewController

            else {
                fatalError()
        }

        masterViewController.delegate = detailViewController
        detailViewController.delegate = self
        detailViewController.navigationItem.leftBarButtonItem = displayModeButtonItem
    }
}

extension MySplitViewController: TestViewControllerDelegate {
    func didTap() {
        preferredDisplayMode = .primaryHidden
    }
}
