//
//  MySplitViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class MySplitViewController: UISplitViewController {

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = UISplitViewController.DisplayMode.allVisible

        guard let leftNavController = viewControllers.first as? UINavigationController,
            let masterViewController = leftNavController.topViewController as? FileListViewController,
            let detailContainerViewController = viewControllers.last as? DetailContainerController,
            let detailHomeViewController = detailContainerViewController.children.first(where: { $0.isKind(of: FileDetailViewController.self) }) as? FileDetailViewController
            else {
                fatalError(description)
        }
        masterViewController.delegate = detailHomeViewController
        detailContainerViewController.navigationItem.leftBarButtonItem = displayModeButtonItem
    }
}
