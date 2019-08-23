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
    func showContentView(_ type: ContentViewType)
}

protocol ContentViewControllerDelegate: class {
    var viewType: ContentViewType { get set }
    func handleToggleMenu()
    func showContentContainerView(_ type: ContentViewType)
}

class ContentViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var textView: HighlightingTextView!
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
    weak var delegate: ContentViewControllerDelegate?
    weak var containerView: ContentContainerController?
    var viewType: ContentViewType = .default
    var currentFile: FileData?

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.highlighDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        splitViewController?.delegate = self

        var leftImage: UIImage?
        var rightImage: UIImage?
        switch viewType {
        case .default:
            textView?.state = .highlighting
            leftImage = UIImage(named: Button.left.imageName)
            rightImage = UIImage(named: Button.right.imageName)
        case .result:
            leftImage = UIImage(named: Button.close.imageName)
            rightImage = UIImage(named: Button.right.imageName)
        }

        navigationView.configure(title: "", leftButtonImage: leftImage, rightButtonImage: rightImage)

        if let displayMode = splitViewController?.displayMode {
            navigationView.updateButton(displayMode: displayMode)
        }

        configureBottomButton()
    }

    func configureBottomButton() {
        guard let type = delegate?.viewType else {
            preconditionFailure("no type")
        }

        eyeButton.isHidden = type.hideBottomButton
        testButton.isHidden = type.hideBottomButton
        testButton.setTitle(type.testButtonText, for: .normal)
    }

    // MARK: - IBActions

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
        delegate?.handleToggleMenu()
    }

    @IBAction private func didTapTestButton(_ sender: UIButton) {
        guard let controller = UIStoryboard(name: "TestView", bundle: nil).instantiateInitialViewController() as? TestViewController else {
            print("Error!! TestViewController doesn't exist!!")
            return
        }
        controller.file = currentFile
        controller.highlights = textView.highlightings
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
//        HighlightManager.share.saveFile(fileData: fileData)
        // TODO: Save Current Data
        textView.clear()

        // TODO: Get Highligh Data with fileData
        let content = DocumentDataManager.share.readPDF(data.name ?? "")
        navigationView.titleLabel.text = content
        // TODO: Send FileData to HighlightManager
        // HighlightManager will get highlights info for selected file.
//                HighlightManager.share.loadFile(fileData: fileData)
        currentFile = data
        // bind Highlightings to textView
        textView.loadData(content: content, from: [])
    }
}

extension ContentViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        navigationView.updateButton(displayMode: displayMode)
    }
}

extension ContentViewController: HighlightingTextViewDelegate {
    func didAdd(_ highlight: Highlight) {

    }

    func didRemove(_ highlight: Highlight) {

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
