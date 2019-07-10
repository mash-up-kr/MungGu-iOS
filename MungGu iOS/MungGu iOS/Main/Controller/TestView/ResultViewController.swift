//
//  DetailTestViewController.swift
//  MungGu iOS
//
//  Created by Cloud on 08/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class ResultViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var naviBar: UIView!
    @IBOutlet weak var blindButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var gradeView: UIView!
    @IBOutlet weak var animateDot: NVActivityIndicatorView!

    // MARK: - Properties
    weak var delegate: ContainerViewControllerDelegate?
    var isHide = false

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideAll()
        UIView.animate(withDuration: 2.0, animations: {
            self.gradeView.alpha = 0
            self.initDot()
        }) { _ in
            self.hideAll()
        }
    }

    // MARK: - Handlers
    func initDot() {
        animateDot.color = .orange
        animateDot.type = .ballPulse
        animateDot.startAnimating()
    }

    func hideAll() {
        isHide.toggle()
        redoButton.isHidden = isHide
        naviBar.isHidden = isHide
        blindButton.isHidden = isHide
        textView.isHidden = isHide
    }

    // MARK: - IBActions
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
