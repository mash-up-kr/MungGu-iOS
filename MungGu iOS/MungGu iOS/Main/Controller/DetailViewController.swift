//
//  DetailViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UISplitViewControllerDelegate {

    // MARK: - Properties
    var isExpanded = false
    @IBOutlet weak var toggleSlideMenuConstraint: NSLayoutConstraint!

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Handlers

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homeViewController = segue.destination as? DetailHomeViewController
        homeViewController?.delegate = self
        print(homeViewController?.delegate)
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    func animatePanel(shouldExpanded: Bool) {
        if shouldExpanded {
            toggleSlideMenuConstraint.constant = 0
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
                self?.view.layoutIfNeeded()
                }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.25) {
                self.toggleSlideMenuConstraint.constant = -320
                self.view.layoutIfNeeded()
            }
        }
        animateStatusBar()
    }

    func animateStatusBar() {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}

extension DetailViewController: DeatilHomeDelegate {

    func handleToggle(sender: UIButton) {
        //
        if isExpanded {
            sender.setImage(#imageLiteral(resourceName: "iconImportantR"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "iconExpand"), for: .normal)

        }
        isExpanded.toggle()
        animatePanel(shouldExpanded: isExpanded)
    }
}

extension DetailViewController: MasterViewControllerDelegate {
    func didselect(with data: File) {

    }

}
