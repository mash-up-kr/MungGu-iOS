//
//  DetailViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class FileDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var textView: HighlightingTextView!
    @IBOutlet weak var rightMenuButton: UIButton!
    @IBOutlet weak var leftMenuButton: UIButton!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var fileLabel: UILabel!

    // MARK: - Properties
    private var currentButtonImage: UIImage?
    private var file: File?
    weak var containderDelegate: ContainerViewControllerDelegate?

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        textView?.isGestureEnable = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        splitViewController?.delegate = self
        if let displayMode = splitViewController?.displayMode {
            updateButton(displayMode: displayMode)
        }
    }

    // MARK: - Handlers

    func updateButton(displayMode: UISplitViewController.DisplayMode) {
        rightMenuButton.isHidden = displayMode == .allVisible
        leftMenuButton.setImage(Button.left.image(displayMode: displayMode), for: .normal)
    }

    // MARK: - IBActions
    @IBAction private func didTapLeftMenu(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            let primaryHidden = self.splitViewController?.preferredDisplayMode ?? .primaryHidden
            self.splitViewController?.preferredDisplayMode = primaryHidden == .allVisible ? .primaryHidden : .allVisible
        })
    }

    @IBAction private func didTapRightMenu(_ sender: UIButton) {
        sender.isSelected.toggle()
        containderDelegate?.handleToggleMenu()
    }

    @IBAction private func didTapTestButton(_ sender: UIButton) {
        guard let testNavigationController = storyboard?.instantiateViewController(withIdentifier: "testNavigationController") as? UINavigationController,
            let testViewController = testNavigationController.topViewController as? TestViewController
        else {
            preconditionFailure("can not find TestViewController")
        }
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
        testViewController.bind(file, highlightData: textView.highlightData)

//        let service = Service.quiz(method: .post, data: <#T##Encodable#>, fileID: <#T##String#>)

//        textView.highlightings.map { highlight -> Sequence in
//            highlight.range
//        }
//        Hightlight(id: nil, fileId: 1, startIndex: <#T##Int?#>, endInex: <#T##Int?#>, content: <#T##String?#>, type: <#T##HightlightType?#>, isImportant: <#T##Bool?#>)
//        NetworkManager.share.request(, completion: <#T##(Response) -> Void#>)
        present(testNavigationController, animated: true, completion: nil)
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

extension FileDetailViewController: FilesViewControllerDelegate {
    func didSelected(with data: File) {
        textView.text = data.content
        fileLabel.text = data.title
        file = data
    }
}

extension FileDetailViewController: ContainerViewControllerDelegate {
    func handleToggleMenu() {
        containderDelegate?.handleToggleMenu()
    }
}

extension FileDetailViewController: UISplitViewControllerDelegate {

    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        updateButton(displayMode: displayMode)
    }

}

extension FileDetailViewController {

    enum Button {
        case left
        case right
        case expanded

        var imageName: String {
            switch self {
            case .left: return "iconMenu"
            case .right: return "iconToggle"
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
