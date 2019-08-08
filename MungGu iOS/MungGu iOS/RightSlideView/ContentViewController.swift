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
    weak var presentDelegate: PresentDelegate?
    var viewType: ContentViewType = .default
    var file: File?

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        textView?.isGestureEnable = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        splitViewController?.delegate = self

        var leftImage: UIImage? = nil
        var rightImage: UIImage? = nil
        var rightTitle: String = ""
        switch viewType {
        case .default:
            leftImage = UIImage(named: Button.left.imageName)
            rightImage = UIImage(named: Button.right.imageName)
        case .test:
            leftImage = UIImage(named: Button.close.imageName)
            rightTitle = "채점하기"
        case .result:
            leftImage = UIImage(named: Button.close.imageName)
            rightImage = UIImage(named: Button.right.imageName)
        }

        navigationView.configure(title: "", leftButtonImage: leftImage, rightButtonImage: rightImage, rightButtonTitle: rightTitle)

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
        case .test, .result:
            dismiss(animated: true, completion: nil)
        }
    }

    @objc private func didTapRightMenu(_ sender: UIButton) {
        switch viewType {
        case .default, .result:
            sender.isSelected.toggle()
            delegate?.handleToggleMenu()
        case .test:
            let requestTest = QuizzesRequest(answers: [Answer(userAnswer: "안녕"), Answer(userAnswer: "잘가"), Answer(userAnswer: "바이")])
            let service = Service.quiz(method: .post, data: requestTest, fileID: file?.id ?? "")
            Provider.request(service, completion: { (data: QuizzesResponse) in
                print("quiz result: \(data)")
                
                self.dismiss(animated: true) {
                    self.presentDelegate?.showContentView(.result)
                }
            }) { error in
                print("quiz result error: \(error)")
            }
            
        }
    }

    @IBAction private func didTapTestButton(_ sender: UIButton) {
        delegate?.showContentContainerView(.test)
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
