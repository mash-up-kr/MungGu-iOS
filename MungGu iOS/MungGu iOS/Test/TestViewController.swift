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

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    // MARK: - Properties

    var file: FileData?

    func configure() {
        let content = DocumentDataManager.share.readPDF(file?.name ?? "")
        navigationView.titleLabel.text = content
        textView.loadData(content: content, from: [])
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
        let requestTest = QuizzesRequest(answers: [Answer(userAnswer: "안녕"), Answer(userAnswer: "잘가"), Answer(userAnswer: "바이")])
        let service = Service.quiz(method: .post, data: requestTest, fileID: "\(fileId)")
        Provider.request(service, completion: { (data: QuizzesResponse) in
            print("quiz result: \(data)")

//            self.dismiss(animated: true) {
//                self.presentDelegate?.showContentView(.result)
//            }
        }) { error in
//            self.dismiss(animated: true) {
//                self.presentDelegate?.showContentView(.result)
//            }
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
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TestViewCell", for: indexPath) as? TestViewCell else { return UITableViewCell() }
        return cell
    }
}

extension TestViewController: UITableViewDelegate {

}
