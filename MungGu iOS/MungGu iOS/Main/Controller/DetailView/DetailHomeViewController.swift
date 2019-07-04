//
//  DetailViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UISplitViewControllerDelegate {

    // MARK: - Properties
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var eyeButton: UIButton!
    var hide = false
    var file: File? {
        didSet {
            refreshUI()
        }
    }
    var delegate: HomeControllerDelegate?

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleButton.isHidden = true
    }

    // MARK: - Handlers
    func refreshUI() {
        loadViewIfNeeded()
        textView?.text = file?.content
    }

    func hideExpandButton() {
        if  hide {
            toggleButton.isHidden = true
        } else {
            toggleButton.isHidden = false
        }
        hide.toggle()
    }

    func hideToggleButton() {
        if hide {
            expandButton.isHidden = true
        } else {
            expandButton.isHidden = false
        }
        hide.toggle()
    }

    @IBAction private func expandBtn(_ sender: UIButton) {
        hideExpandButton()
        self.splitViewController?.delegate = self
        let primaryHidden = splitViewController?.preferredDisplayMode ?? .primaryHidden
        splitViewController?.preferredDisplayMode = primaryHidden == .allVisible ? .primaryHidden : .allVisible
    }

    @IBAction private func toggleMenu(_ sender: UIButton) {
        hideToggleButton()
        delegate?.handleToggleMenu(btn: sender)
    }

    @IBAction private func goTest(_ sender: UIButton) {
    }

    @IBAction private func blindText(_ sender: UIButton) {
        eyeButton.isSelected.toggle()
    }
}

extension DetailViewController: MasterViewControllerDelegate {
    func didselect(with data: File) {
        print(data)
        textView.text = data.content
    }
}

extension DetailViewController: HomeControllerDelegate {
    func handleToggleMenu(btn: UIButton) {
        delegate?.handleToggleMenu(btn: btn)
    }
}

extension DetailViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
