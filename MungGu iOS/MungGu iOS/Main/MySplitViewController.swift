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
        self.preferredDisplayMode = UISplitViewController.DisplayMode.allVisible
        
        guard let leftNavController = viewControllers.first as? UINavigationController,
            let masterViewController = leftNavController.topViewController as? MasterViewController,
            let detailViewController = viewControllers.last as? DetailViewController
            else {
                fatalError()
        }
        masterViewController.delegate = detailViewController
        detailViewController.navigationItem.leftBarButtonItem = displayModeButtonItem
    }
}
