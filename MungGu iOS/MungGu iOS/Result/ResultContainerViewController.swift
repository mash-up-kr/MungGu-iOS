//
//  TestContainerController.swift
//  MungGu iOS
//
//  Created by Cloud on 08/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation
import UIKit

class ResultContainerViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var toggleSlideMenuConstraint: NSLayoutConstraint!

    // MARK: - Properties
    var isExpanded = false
    var fileTitle: String?

    var viewType: ContentViewType = .default

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Handers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homeViewController = segue.destination as? ResultViewController
//        homeViewController?.delegate = self
        homeViewController?.fileTile = self.fileTitle
    }

    func animatePanel(shouldExpanded: Bool) {
        toggleSlideMenuConstraint.constant = shouldExpanded ? 0 : -320
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

extension ResultContainerViewController: ContentViewControllerDelegate {
    func showContentContainerView(_ type: ContentViewType) {

    }

    func handleToggleMenu() {
        isExpanded.toggle()
        animatePanel(shouldExpanded: isExpanded)
    }
}
