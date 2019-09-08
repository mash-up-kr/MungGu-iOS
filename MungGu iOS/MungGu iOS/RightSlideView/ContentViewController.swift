//
//  ContentViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

typealias ContentViewButton = ContentViewController.Button

protocol PresentDelegate: class {
    func showContentView(_ type: ContentViewType, result: QuizzesResponse, highlights: [Highlight])
}

protocol ContentViewControllerDelegate: class {
    var viewType: ContentViewType { get set }
    func handleToggleMenu()
    func showContentContainerView(_ type: ContentViewType, result: QuizzesResponse, highlights: [Highlight])
}

class ContentViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var textView: HighlightingTextView! {
        didSet {
            textView.contentInset = UIEdgeInsets(top: 31.0, left: 0.0, bottom: 112.0, right: 0.0)
        }
    }
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var navigationView: CommonNavigationView! {
        didSet {
            navigationView.leftButton.addTarget(self, action: #selector(didTapLeftMenu), for: .touchUpInside)
            navigationView.rightButton.addTarget(self, action: #selector(didTapRightMenu), for: .touchUpInside)
        }
    }

    // MARK: - Properties

    private var currentButtonImage: UIImage?
    private lazy var highlightManager: HighlightManagerType = HighlightManager.share
    weak var delegate: ContentViewControllerDelegate?
    weak var containerView: ContentContainerController?
    var viewType: ContentViewType = .default
    var currentFile: FileData?
    var result: QuizzesResponse?

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.highlighDelegate = self

        var leftImage: UIImage?
        var rightImage: UIImage?
        switch viewType {
        case .default:
            textView?.state = .highlighting
            leftImage = UIImage(named: Button.left.imageName)
            rightImage = UIImage(named: Button.right.imageName)
        case .result:
            textView?.state = .result
            leftImage = UIImage(named: Button.close.imageName)
            rightImage = UIImage(named: Button.right.imageName)
            buttonStackView.isHidden = false
            testButton.isHidden = true
        }

        navigationView.configure(title: "", leftButtonImage: leftImage, rightButtonImage: rightImage)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        splitViewController?.delegate = self

        if let displayMode = splitViewController?.displayMode {
            navigationView.updateButton(displayMode: displayMode)
        }

        configureBottomButton(viewType)

        if let name = currentFile?.name {
            navigationView.titleLabel.text = name
        }
    }

    func configureBottomButton(_ viewType: ContentViewType) {
        testButton.setTitle(viewType.testButtonText, for: .normal)
    }

    // MARK: - IBActions

    func didChangeHighlightImportant() {
        let highlightings = HighlightManager.share.getHighlights()

        DispatchQueue.main.async {
            self.textView.updateTextView(from: highlightings)
            self.textView.setNeedsDisplay()
        }
    }

    @objc private func didTapLeftMenu(_ sender: UIButton) {
        switch viewType {
        case .default:
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                let primaryHidden = self.splitViewController?.preferredDisplayMode ?? .primaryHidden
                self.splitViewController?.preferredDisplayMode = primaryHidden == .allVisible ? .primaryHidden : .allVisible
            })
        case .result:
            dismiss(animated: true, completion: nil)
        }
    }

    @objc private func didTapRightMenu(_ sender: UIButton) {
        sender.isSelected.toggle()
        navigationView.leftButton.isEnabled = !sender.isSelected

        delegate?.handleToggleMenu()
    }

    @IBAction private func didTapTestButton(_ sender: UIButton) {
        guard let fileId = currentFile?.id else { return }

        let highlights = Highlights(highlights: textView.highlightings)
        let service = Service.highlight(method: .post, data: highlights, fileID: "\(fileId)")

        containerView?.loadingView.isHidden = false
        Provider.request(service, completion: { (data: Highlights) in
            let service = Service.quiz(method: .get, data: nil, fileID: "\(fileId)")

            Provider.request(service, completion: { (data: QuizzesResult) in
                var highlights: [Highlight] = []
                data.quizzes.forEach({ quiz in
                    let highlight = Highlight(id: nil, startIndex: quiz.startIndex, endIndex: quiz.endIndex, content: nil, isImportant: 0)
                    highlights.append(highlight)
                })
                self.containerView?.loadingView.isHidden = true
                self.presentTestView(highlights)
            })
        })
    }

    func presentTestView(_ highlights: [Highlight]) {
        guard let controller = UIStoryboard(name: "TestView", bundle: nil).instantiateInitialViewController() as? TestViewController else {
            print("Error!! TestViewController doesn't exist!!")
            return
        }
        controller.file = currentFile
        controller.highlights = highlights
        controller.presentDelegate = containerView

        present(controller, animated: true, completion: nil)
    }

    @IBAction private func blindText(_ sender: UIButton) {
        if eyeButton.isSelected {
            textView.showHighlightedText()
        } else {
            textView.hideHighlightedText()
        }
        eyeButton.isSelected.toggle()
    }

    @IBAction private func unwind(segue: UIStoryboardSegue) { }
}

extension ContentViewController: FilesViewControllerDelegate {
    func didSelected(with data: FileData) {

        // 같은 파일 선택 시 동작수행하지 않음
        guard data.id != currentFile?.id else {
            return
        }

        let highlightings = textView.highlightings
        HighlightManager.share.saveFile(highlightings)
        textView.clear()

        // TODO: Get Highligh Data with fileData
        let content = DocumentDataManager.share.readPDF(data.name ?? "")
        navigationView.titleLabel.text = data.name
        // TODO: Send FileData to HighlightManager
        // HighlightManager will get highlights info for selected file.
        HighlightManager.share.loadFile(fileData: data)
        currentFile = data
        // bind Highlightings to textView
        textView.loadData(content: content, from: [])
    }
}

extension ContentViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        navigationView.updateButton(displayMode: displayMode)

        let hide = displayMode == .allVisible
        if !hide {
            self.buttonStackView.isHidden = false
        }

        UIView.animate(withDuration: 1.0, animations: {
            self.buttonStackView.alpha = hide ? 0 : 1.0
        }) { _ in
            if hide {
                self.buttonStackView.isHidden = true
            }
        }
    }
}

extension ContentViewController: HighlightingTextViewDelegate {
    func didAdd(_ highlight: Highlight) {
        highlightManager.highlights.append(highlight)
    }

    func didRemove(_ highlight: Highlight) {
        // FIXME: highlight의 id 값이 현재 없음..
        guard let index = highlightManager.highlights.firstIndex(where: { $0.startIndex == highlight.startIndex }) else {
            return
        }
        highlightManager.highlights.remove(at: index)
    }

    func didTap(_ highlight: Highlight) {

    }

    func didChange(state: HighlightingTextViewState) {
        DispatchQueue.main.async {
            switch state {
            case .highlighting:
                self.textView.showHighlightedText()
            case .test:
                self.textView.hideHighlightedText()
            case .hide:
                self.textView.hideHighlightedText()
            case .result:
                guard let results = self.result?.result else { return }
                self.textView.updateTextView(results: results)
            }
            self.textView.isGestureEnable = state != .test
            self.textView.setNeedsDisplay()
        }
    }
}

extension ContentViewController {
    enum Button {
        case left
        case right
        case expanded
        case close

        var imageName: String {
            switch self {
            case .left: return "iconMenu"
            case .right: return "iconImportantMenu"
            case .expanded: return "iconExpand"
            case .close: return "iconMenu-1"
            }
        }

        func image(displayMode: UISplitViewController.DisplayMode) -> UIImage? {
            if displayMode == .allVisible {
                return UIImage(named: Button.expanded.imageName)
            }
            return UIImage(named: imageName)
        }
    }
}

private extension CommonNavigationView {
    func updateButton(displayMode: UISplitViewController.DisplayMode) {
        rightButton.isHidden = displayMode == .allVisible
        leftButton.setImage(ContentViewButton.left.image(displayMode: displayMode), for: .normal)
    }
}
