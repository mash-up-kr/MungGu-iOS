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
        case result

        var testButtonText: String? {
            switch self {
            case .default:
                return "Go test!"
            case .result:
                return "Re do!"
            }
        }
    }

    // MARK: - IBOutlet

    @IBOutlet weak var toggleSlideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var rightSlideView: UIView!
    @IBOutlet weak var loadingView: UIView!

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
            contentViewController?.containerView = self
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

    func showContentContainerView(_ type: ContentViewType, result: QuizzesResponse, highlights: [Highlight]) {

        present(type, result: result, highlights: highlights)

    }

    func present(_ type: ContentViewType, result: QuizzesResponse, highlights: [Highlight]) {
        guard let viewController = UIStoryboard(name: "RightSlideView", bundle: nil).instantiateInitialViewController() as? ContentContainerController else {
            preconditionFailure("can not find TestViewController")
        }
        self.rightSliderViewController = viewController.children.first as? RightSlideMenuViewController
        viewController.viewType = type

        // FIXME: 정리 필요
        present(viewController, animated: true, completion: {
            if let fileData = self.contentViewController?.currentFile {
                let documentType = self.contentViewController?.documentType ?? .pdf
                viewController.contentViewController?.documentType = documentType

                var content: String
                switch documentType {
                case .pdf:
                    content = DocumentDataManager.share.readPDF(fileData.name ?? "")
                case .txt:
                    content = DocumentDataManager.share.readText(fileData.name ?? "")
                }

                let highlightTextView = viewController.contentViewController?.textView
                viewController.contentViewController?.result = result
                viewController.contentViewController?.configureBottomButton(.result)

               viewController.contentViewController?.textView.state = .result
                viewController.contentViewController?.navigationView.titleLabel.text = self.contentViewController?.currentFile?.name

                highlightTextView?.loadData(content: content, from: highlights)
                viewController.rightSliderViewController?.result = result
               viewController.rightSliderViewController?.highlightings = highlights
                 viewController.rightSliderViewController?.filteredHighlightings = highlights
                viewController.rightSliderViewController?.filteredResult = result.result
                viewController.rightSliderViewController?.setTest(type)
                viewController.contentViewController?.textView.isGestureEnable = false
            }
        })
    }
}

extension ContentContainerController: PresentDelegate {
    func showContentView(_ type: ContentViewType, result: QuizzesResponse, highlights: [Highlight]) {
        showContentContainerView(type, result: result, highlights: highlights)
    }
}

extension ContentContainerController: RightSlideMenuViewControllerDelegate {
    func didChange(highlight: Highlight) {
        guard let textView = contentViewController?.textView else { return }
        var highlightings = textView.highlightings
        guard let indexPath = highlightings.firstIndex(where: { $0.startIndex == highlight.startIndex && $0.endIndex == highlight.endIndex }) else {
            return
        }
        textView.updateTextView(with: highlight)
        highlightings[indexPath].isImportant = highlightings[indexPath].isImportant == 0 ? 1 : 0
        HighlightManager.share.highlights = highlightings
        contentViewController?.didChangeHighlightImportant()
    }

    func didSelect(highlight: Highlight) {
        contentViewController?.textView.scrollRangeToVisible(highlight.range)
    }

    func didDelete(highlight: Highlight) {
        contentViewController?.textView.removeHighlight(highlight)
    }

    func test() {

    }
}
