//
//  ContentContainerController.swift
//  MungGu iOS
//
//  Created by Cloud on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation
import UIKit

typealias ContentViewType = ContentContainerController.ViewType
class ContentContainerController: UIViewController {

    enum ViewType {
        case `default`
        case test
        case result

        var hideBottomButton: Bool {
            switch self {
            case .test, .result:
                return true
            default:
                return false
            }
        }

        var testButtonText: String? {
            switch self {
            case .default:
                return "Go test!"
            case .result:
                return "Re do!"
            default:
                return nil
            }
        }
    }

    // MARK: - IBOutlet

    @IBOutlet weak var toggleSlideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var rightSlideView: UIView!

    // MARK: - Properties

    var isExpanded = true
    var viewType: ViewType = .default
    var contentViewController: ContentViewController?

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Handlers

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ContentViewController {
            contentViewController = viewController
            contentViewController?.delegate = self
            contentViewController?.viewType = viewType
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

extension ContentContainerController: ContentViewControllerDelegate {
    func handleToggleMenu() {
        animatePanel(shouldExpanded: isExpanded)
        isExpanded.toggle()
    }

    func showContentContainerView(_ type: ContentViewType) {
        guard let viewController = UIStoryboard(name: "RightSlideView", bundle: nil).instantiateInitialViewController() as? ContentContainerController else {
            preconditionFailure("can not find TestViewController")
        }

        viewController.viewType = type
        present(viewController, animated: true, completion: {
            viewController.contentViewController?.presentDelegate = self
        })
    }
}

extension ContentContainerController: PresentDelegate {
    func showContentView(_ type: ContentViewType) {
        showContentContainerView(type)
    }
}
