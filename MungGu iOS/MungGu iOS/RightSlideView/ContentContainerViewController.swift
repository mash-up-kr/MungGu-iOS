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
    var rightSlideViewController: RightSlideMenuViewController?

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
        } else if let viewController = segue.destination as? RightSlideMenuViewController {
            rightSlideViewController = viewController
            rightSlideViewController?.delegate = self
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
        switch type {
        case .test:
            if let highlightings = contentViewController?.textView.highlightings, let id = contentViewController?.file?.id {
                let highlights = Highlights(highlights: highlightings)
                let service = Service.highlight(method: .post, data: highlights, fileID: id)

                Provider.request(service, completion: { (_: Highlights) in
                    let quizService = Service.quiz(method: .get, data: nil, fileID: id)
                    Provider.request(quizService, completion: { (data: QuizzesResult) in
                        self.present(type, highlightings: highlightings)
                    }) { error in
                        print("### quiz: \(error)")
                    }
                }) { error in
                    print("### highlights: \(error)")
                }

            }

        case .result:
            present(type, highlightings: contentViewController?.textView.highlightings)
        default:
            present(type)
        }

    }

    func present(_ type: ContentViewType, highlightings: [Highlight]? = nil) {
        guard let viewController = UIStoryboard(name: "RightSlideView", bundle: nil).instantiateInitialViewController() as? ContentContainerController else {
            preconditionFailure("can not find TestViewController")
        }

        viewController.viewType = type
        present(viewController, animated: true, completion: {
            viewController.contentViewController?.presentDelegate = self

            if let content = self.contentViewController?.file?.content, let highlightings = highlightings {
                viewController.contentViewController?.textView.loadData(content: content, from: highlightings)
                viewController.rightSlideViewController?.setTest(type)
                if type == .test {
                    viewController.contentViewController?.testContentView.isHidden = false
                }
            }
        })
    }
}

extension ContentContainerController: PresentDelegate {
    func showContentView(_ type: ContentViewType) {
        showContentContainerView(type)
    }
}

extension ContentContainerController: RightSlideMenuViewControllerDelegate {
    func test() {

    }
}
