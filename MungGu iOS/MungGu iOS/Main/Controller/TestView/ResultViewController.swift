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
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var naviBar: UIView!
    @IBOutlet weak var blindButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var gradeView: UIView!
    var delegate: ContainerViewControllerDelegate?
    var isHide = false

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        hideAll()
        UIView.animate(withDuration: 2.0, animations: {
            self.gradeView.alpha = 0
        }) { _ in
            self.hideAll()
        }
    }

    // MARK: - Handlers
    func hideAll() {
        isHide.toggle()
        redoButton.isHidden = isHide
        naviBar.isHidden = isHide
        blindButton.isHidden = isHide
        textView.isHidden = isHide
    }
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
