//
//  Test.swift
//  MungGu iOS
//
//  Created by Cloud on 09/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation
import UIKit

class TestViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var textView: HighlightingTextView!
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!

    // MARK: - Properties
    private var file: File!
    private var highlightData: HighlightData!

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = file.title
        self.textView.attributedText = highlightData.attributedString
        self.addNotification()
        textView.loadData(from: highlightData, state: .test, isGestureEnable: true)
        textView.highlighDelegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController = segue.destination as? ResultContainerViewController
        resultViewController?.fileTitle = file.title
    }

    func bind(_ file: File, highlightData: HighlightData) {
        self.file = file
        self.highlightData = highlightData
    }

    // MARK: - IBActions
    @IBAction private func exit(_ sender: Any) {
        let alertViewController = UIAlertController(.exitText)
        alertViewController.addAction(UIAlertAction(title: "종료", style: .destructive) { [weak self] _ in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        })
        alertViewController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }

    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        inputViewBottomConstraint.constant = keyboardFrame.height
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }

    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        inputViewBottomConstraint.constant = 0
        UIView.animate(withDuration: duration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func didTapOK(_ sender: UIButton) {

    }

}

extension TestViewController: HighlightingTextViewDelegate {
    func didChange(state: HighlightingTextViewState) {

    }

    func didTap(_ highlight: Highlight) {
        self.answerField.becomeFirstResponder()
        self.textView.scrollRangeToVisible(highlight.range)
    }

}
