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
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailHome") as! DetailViewController

        super.viewDidLoad()
        preferredDisplayMode = UISplitViewController.DisplayMode.allVisible

        guard let leftNavController = viewControllers.first as? UINavigationController,
            let masterViewController = leftNavController.topViewController as? MasterViewController,
            let detailContainerViewController = viewControllers.last as? DetailContainerController
            else {
                fatalError(description)
        }
        masterViewController.delegate = homeViewController
        detailContainerViewController.navigationItem.leftBarButtonItem = displayModeButtonItem
    }
}

extension MySplitViewController: TestViewControllerDelegate {
    func didTap() {
        preferredDisplayMode = .primaryHidden
    }
}
