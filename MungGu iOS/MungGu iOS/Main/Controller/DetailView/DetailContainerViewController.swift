//
//  DetailHomeViewController.swift
//  MungGu iOS
//
//  Created by Cloud on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation
import UIKit

class DetailContainerController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var toggleSlideMenuConstraint: NSLayoutConstraint!

    // MARK: - Properties
    var isExpanded = true

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Handlers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? FileDetailViewController {
            detailViewController.containderDelegate = self
        }
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    func animatePanel(shouldExpanded: Bool) {
        if shouldExpanded {
            toggleSlideMenuConstraint.constant = 0
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            toggleSlideMenuConstraint.constant = -320
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            }, completion: nil)
            animateStatusBar()
        }
    }

    func animateStatusBar() {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }

}

extension DetailContainerController: ContainerViewControllerDelegate {
    func handleToggleMenu() {
        animatePanel(shouldExpanded: isExpanded)
        isExpanded.toggle()
    }
}
