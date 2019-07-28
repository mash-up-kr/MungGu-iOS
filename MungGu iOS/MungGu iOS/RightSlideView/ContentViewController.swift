//
//  ContentViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

typealias ContentViewButton = ContentViewController.Button

protocol ContentViewControllerDelegate: class {
    var viewType: ContentViewType { get set }
    func handleToggleMenu()
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
    private var file: File?
    weak var delegate: ContentViewControllerDelegate?

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        textView?.isGestureEnable = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        splitViewController?.delegate = self

        navigationView.configure(title: "", leftButtonImage: UIImage(named: Button.left.imageName), rightButtonImage: UIImage(named: Button.right.imageName))
        if let displayMode = splitViewController?.displayMode {
            navigationView.updateButton(displayMode: displayMode)
        }

        configureBottomButton()

        print("Test.. current viewType: \(delegate?.viewType)")
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
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            let primaryHidden = self.splitViewController?.preferredDisplayMode ?? .primaryHidden
            self.splitViewController?.preferredDisplayMode = primaryHidden == .allVisible ? .primaryHidden : .allVisible
        })
    }

    @objc private func didTapRightMenu(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.handleToggleMenu()
    }

    @IBAction private func didTapTestButton(_ sender: UIButton) {
        // TODO: 테스트 뷰 띄우기
        guard let testViewController = UIStoryboard(name: "RightSlideView", bundle: nil).instantiateInitialViewController() as? ContentContainerController else {
            preconditionFailure("can not find TestViewController")
        }

        testViewController.viewType = .test

        print("aaa \(testViewController.contentViewController)")
        present(testViewController, animated: true, completion: nil)
        /*
        guard let file = self.file else {
            let alert = UIAlertController(.noFile)
            alert.addAction(alert.defaultConfirmAction)
            present(alert, animated: true)
            return
        }
        guard !textView.highlightings.isEmpty else {
            let alert = UIAlertController(.noHighlighting)
            alert.addAction(alert.defaultConfirmAction)
            present(alert, animated: true)
            return
        }
        
        testViewController.bind(file, highlights: textView.highlightings)
        // TODO: Save Dataß
        present(testNavigationController, animated: true, completion: nil)
 
         */
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
    func didSelected(with data: File) {
        // TODO: Save Data
        let highlightings = textView.highlightings
        textView.clear()
        // TODO: Get Data
        navigationView.titleLabel.text = data.title
        file = data
        // bind Highlightings to textView
        textView.loadData(content: data.content, from: [])
    }
}

extension ContentViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        navigationView.updateButton(displayMode: displayMode)
    }
}

extension ContentViewController {
    enum Button {
        case left
        case right
        case expanded

        var imageName: String {
            switch self {
            case .left: return "iconMenu"
            case .right: return "iconImportantMenu"
            case .expanded: return "iconExpand"
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
