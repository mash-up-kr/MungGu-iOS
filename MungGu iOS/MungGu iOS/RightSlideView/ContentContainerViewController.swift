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
    weak var rightSliderViewController: RightSlideMenuViewController?

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
            rightSliderViewController = viewController
            rightSliderViewController?.delegate = self
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
        if isExpanded {
            guard let highlightings = contentViewController?.textView.highlightings else { return }
            rightSliderViewController?.highlightings = highlightings
        }
    }

    func showContentContainerView(_ type: ContentViewType) {
        switch type {
        case .test:
            if let highlightings = contentViewController?.textView.highlightings, let id = contentViewController?.currentFile?.id {
                let highlights = Highlights(highlights: highlightings)
                let fileIdString = String(id)
                let service = Service.highlight(method: .post, data: highlights, fileID: fileIdString)

                Provider.request(service, completion: { (_: Highlights) in
                    let quizService = Service.quiz(method: .get, data: nil, fileID: fileIdString)
                    Provider.request(quizService, completion: { (data: QuizzesResult) in
                        let highlights: [Highlight] = data.quizzes.map { Highlight(quiz: $0) }
                        self.present(type, highlightings: highlights)
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
        self.rightSliderViewController = viewController.children.first as? RightSlideMenuViewController
        viewController.viewType = type
        present(viewController, animated: true, completion: {
            viewController.contentViewController?.presentDelegate = self

            if let fileData = self.contentViewController?.currentFile, let highlightings = highlightings {
                let content = DocumentDataManager.share.readPDF(fileData.name ?? "")
                let highlightTextView = viewController.contentViewController?.textView
                highlightTextView?.state = (type == .test) ? .test : .highlighting
                highlightTextView?.loadData(content: content, from: highlightings)
                viewController.rightSliderViewController?.setTest(type)
                if type == .test {
                    viewController.contentViewController?.testContentView.isHidden = false
                    viewController.contentViewController?.textView
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
