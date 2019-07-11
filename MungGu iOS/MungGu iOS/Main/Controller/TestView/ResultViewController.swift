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
    @IBOutlet weak var fileLabel: UILabel!

    // MARK: - Properties
    weak var delegate: ContainerViewControllerDelegate?
    var isHide = false
    var fileTile: String?
    let alert = UIAlertController(title: "경고", message: "시험 본 히스토리가 삭제됩니다.", preferredStyle: .alert
    )

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initAlert()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideAll()
        UIView.animate(withDuration: 2.0, animations: {
            self.gradeView.alpha = 0
            self.initDot()
        }) { _ in
            self.hideAll()
            self.fileLabel.text = self.fileTile
        }
    }

    // MARK: - Handlers
    @objc func dismissFunc() {
        alert.dismiss(animated: true, completion: nil)
    }
    func initAlert() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(dismissFunc), name: UIApplication.willResignActiveNotification, object: nil)

        let backAlertAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.performSegue(withIdentifier: "unwindViewController", sender: self)
        }
        let cancleAlertAction = UIAlertAction(title: "취소", style: .cancel) { _ in
        }
        alert.addAction(cancleAlertAction)
        alert.addAction(backAlertAction)
    }
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
        present(alert, animated: true, completion: nil)
    }

}

extension ResultViewController: ContainerViewControllerDelegate {
    func handleToggleMenu() {
        delegate?.handleToggleMenu()
    }
}
