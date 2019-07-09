//
//  DetailTestViewController.swift
//  MungGu iOS
//
//  Created by Cloud on 08/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var textView: UITextView!
    var delegate: ContainerViewControllerDelegate?
    

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Handlers
    @IBAction private func redoButton(_ sender: UIButton) {

    }
    @IBAction private func blindButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    @IBAction private func toggleSlide(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.handleToggleMenu()
    }
    @IBAction private func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindViewController", sender: self)
    }
}

extension ResultViewController: ContainerViewControllerDelegate {
    func handleToggleMenu() {
        delegate?.handleToggleMenu()
    }
}
