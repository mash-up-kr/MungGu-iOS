//
//  DetailHomeViewController.swift
//  MungGu iOS
//
//  Created by Cloud on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class DetailHomeViewController: UIViewController {
    // MARK: - Properties
    var delegate: DeatilHomeDelegate?
    @IBOutlet weak var toggleMenuButton: UIButton!
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
    }
// MARK: - Handlers

    @IBAction func expandBtn(_ sender: Any) {
//        self.splitViewController?.delegate = self

        let primaryHidden = splitViewController?.preferredDisplayMode ?? .primaryHidden
        splitViewController?.preferredDisplayMode = primaryHidden == .allVisible ? .primaryHidden : .allVisible

        if primaryHidden == .allVisible {
            // 비활성화
        } else {
            // 활성화
        }
    }

    @IBAction func toggleMenu(_ sender: UIButton) {
        delegate?.handleToggle(sender: sender)

    }
}
