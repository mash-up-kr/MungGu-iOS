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
    private let expandedImage: UIImage = UIImage(named: "iconExpand")!
    private var currentButtonImage: UIImage?
    private var file: File?
    weak var containderDelegate: ContainerViewControllerDelegate?

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        textView?.setupHighlightingGestures()
    }

    override func viewWillAppear(_ animated: Bool) {
        splitViewController?.delegate = self
        if let displayMode = splitViewController?.displayMode {
            updateButton(displayMode: displayMode)
        }
    }

    // MARK: - Handlers

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let testViewController = segue.destination as? TestViewController
        testViewController?.fileTitle = file?.title
    }

    func updateButton(displayMode: UISplitViewController.DisplayMode) {
        rightMenuButton.isHidden = displayMode == .allVisible
        leftMenuButton.setImage(Button.left.image(displayMode: displayMode), for: .normal)
    }

    // MARK: - IBActions
    @IBAction private func tapLeftMenu(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            let primaryHidden = self.splitViewController?.preferredDisplayMode ?? .primaryHidden
            self.splitViewController?.preferredDisplayMode = primaryHidden == .allVisible ? .primaryHidden : .allVisible
        })
    }

    @IBAction private func tapRightMenu(_ sender: UIButton) {
        sender.isSelected.toggle()
        containderDelegate?.handleToggleMenu()
    }

    @IBAction private func goTest(_ sender: UIButton) {
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

        var image: UIImage? {
            switch self {
            case .left:
                return UIImage(named: "iconMenu")
            case .right:
                return UIImage(named: "iconToggle")
            case .expanded:
                return UIImage(named: "iconExpand")
            }
        }

        func image(displayMode: UISplitViewController.DisplayMode) -> UIImage? {
            if displayMode == .allVisible {
                return Button.expanded.image
            }
            return image
        }
    }
}
