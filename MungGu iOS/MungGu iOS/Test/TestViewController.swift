//
//  TestViewController.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 23/08/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var textView: HighlightingTextView!
    @IBOutlet weak var navigationView: CommonNavigationView! {
        didSet {
            navigationView.leftButton.addTarget(self, action: #selector(didTapLeftMenu), for: .touchUpInside)
            navigationView.rightButton.addTarget(self, action: #selector(didTapRightMenu), for: .touchUpInside)
        }
    }

    @IBOutlet weak var firstNumberLabel: UILabel!
    @IBOutlet weak var secondNumberLabel: UILabel!
    @IBOutlet weak var firstAnswerLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    // MARK: - Properties

    var file: FileData?
    var highlights: [Highlight]?
    var answers: [Answer]?

    weak var presentDelegate: PresentDelegate?

    func configure() {
        firstNumberLabel.text = ""
        secondNumberLabel.text = ""
        firstAnswerLabel.text = ""
        textField.delegate = self

        let content = DocumentDataManager.share.readPDF(file?.name ?? "")
        navigationView.titleLabel.text = content
        textView.loadData(content: content, from: highlights ?? [])
        tableView.reloadData()

        let count = highlights?.count ?? 0
        answers = Array(repeating: Answer(userAnswer: ""), count: count)
    }

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.highlighDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configure()
        navigationView.configure(title: "", leftButtonImage: UIImage(named: "iconMenu-1"), rightButtonImage: nil, rightButtonTitle: "채점하기")
    }

    // MARK: - IBActions

    @objc private func didTapLeftMenu(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapRightMenu(_ sender: UIButton) {

        guard let fileId = file?.id else { return }

        let requestTest = QuizzesRequest(answers: answers ?? [])
        let service = Service.quiz(method: .post, data: requestTest, fileID: "\(fileId)")

        Provider.request(service, completion: { (data: QuizzesResponse) in
            print("quiz result: \(data)")

            self.dismiss(animated: true) {
                self.presentDelegate?.showContentView(.result, result: data, highlights: self.highlights ?? [])
            }
        }) { error in
            print("quiz result error: \(error)")
        }
    }
}

extension TestViewController: HighlightingTextViewDelegate {
    func didAdd(_ highlight: Highlight) {

    }

    func didRemove(_ highlight: Highlight) {

    }

    func didTap(_ highlight: Highlight) {
        // TODO:
    }

    func didChange(state: HighlightingTextViewState) {
    }
}

extension TestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highlights?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TestViewCell", for: indexPath) as? TestViewCell else { return UITableViewCell() }
        cell.numberLabel.text = "\(indexPath.row + 1)"

        return cell
    }
}

extension TestViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secondNumberLabel.text = "\(indexPath.row + 1)"
        textField.becomeFirstResponder()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        firstNumberLabel.text = "\(indexPath.row + 1)"
        firstAnswerLabel.text = textField.text

        guard let text = textField.text, !text.isEmpty else { return }

        let cell = tableView.cellForRow(at: indexPath) as? TestViewCell
        cell?.answerLabel.text = text
        answers?[indexPath.row] = Answer(userAnswer: text)
        textField.text = nil
    }
}

extension TestViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = secondNumberLabel.text, let number = Int(text), let answer = textField.text, !answer.isEmpty else {
            return true
        }

        let cell = tableView.cellForRow(at: IndexPath(row: number - 1, section: 0)) as? TestViewCell
        cell?.answerLabel.text = answer
        firstAnswerLabel.text = answer
        firstNumberLabel.text = text
        answers?[number - 1] = Answer(userAnswer: answer)

        textField.text = nil

        return true
    }

//    textField
}
