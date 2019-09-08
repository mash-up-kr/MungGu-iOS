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

        let service = Service.version
        Provider.request(service, completion: { (data: Version) in
            if let appVersionString = DeviceManager.appVersionString,
                let version = data.version, appVersionString != version,
                let link = data.link {

                let alertController = UIAlertController(title: "업데이트", message: "필수 업데이트가 있습니다. 업데이트하시겠습니까?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "업데이트", style: .default, handler: { action in

                    // itms-apps://itunes.apple.com/
                    if let url = URL(string: link),
                        UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:]) { opened in
                            if opened {
                                print("App Store Opened")
                            }
                            exit(-1)
                        }
                    }
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        })

        preferredDisplayMode = UISplitViewController.DisplayMode.allVisible

        guard let leftNavController = viewControllers.first as? UINavigationController,
            let masterViewController = leftNavController.topViewController as? FileListViewController,
            let detailContainerViewController = viewControllers.last as? ContentContainerController,
            let detailHomeViewController = detailContainerViewController.children.first(where: { $0.isKind(of: ContentViewController.self) }) as? ContentViewController
            else {
                fatalError(description)
        }
        masterViewController.delegate = detailHomeViewController
        detailContainerViewController.navigationItem.leftBarButtonItem = displayModeButtonItem
    }
}
