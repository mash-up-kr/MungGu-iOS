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

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Handers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homeViewController = segue.destination as? ResultViewController
        homeViewController?.delegate = self
    }

    func animatePanel(shouldExpanded: Bool) {
        if shouldExpanded {
            toggleSlideMenuConstraint.constant = 0
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                [weak self] in
                self?.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            toggleSlideMenuConstraint.constant = -320
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

extension ResultContainerViewController: ContainerViewControllerDelegate {
    func handleToggleMenu() {
        isExpanded.toggle()
        animatePanel(shouldExpanded: isExpanded)
    }
}
