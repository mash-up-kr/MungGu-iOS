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
    @IBAction func expandBtn(_ sender: Any) {
        self.splitViewController?.delegate = self
        let primaryHidden = splitViewController?.preferredDisplayMode ?? .primaryHidden
        splitViewController?.preferredDisplayMode = primaryHidden == .allVisible ? .primaryHidden : .allVisible
    }
    var file: File? {
        didSet {
            refreshUI()
        }
    }
    var delegate: HomeControllerDelegate?

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Handlers
    func refreshUI() {
        loadViewIfNeeded()
        textView?.text = file?.content
    }

    @IBAction func toggleMenu(_ sender: UIButton) {
        delegate?.handleToggleMenu(btn: sender)
    }
}

extension DetailViewController: MasterViewControllerDelegate {
    func didselect(with data: File) {
        textView.text = data.content
    }
}

extension DetailViewController: HomeControllerDelegate {
    func handleToggleMenu(btn: UIButton) {
        delegate?.handleToggleMenu(btn: btn)
    }
}
