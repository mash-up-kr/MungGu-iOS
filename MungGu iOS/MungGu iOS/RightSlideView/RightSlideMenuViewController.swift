//
//  RightSlideMenuViewController.swift
//  MungGu iOS
//
//  Created by Cloud on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

protocol RightSlideMenuViewControllerDelegate: class {
    func test()
    func didSelect(highlight: Highlight)
    func didChange(highlight: Highlight)
    func didDelete(highlight: Highlight)
}

class RightSlideMenuViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var containerView: UIView!
    @IBOutlet var firstView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.layer.cornerRadius = 3.0
        }
    }
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Properties

    weak var delegate: RightSlideMenuViewControllerDelegate?
    var viewType: ContentViewType = .default
    var highlightings: [Highlight] = []
    private var filteredHighlightings: [Highlight] = []

    var result: QuizzesResponse?

    var filteredResult: [QuizMarkResult]?

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        view.endEditing(true)
        configureDelegate()

        NotificationCenter.default.addObserver(self, selector: #selector(didChangeHighlights), name: HighlightManager.DidChangedHighlights, object: nil)
        highlightings = HighlightManager.share.getHighlights()
        filteredHighlightings = highlightings
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        switch viewType {
        case .default:
            containerView.isHidden = false
        default:
            containerView.isHidden = true
        }

        filteredResult = result?.result
    }

    // MARK: - Handlers
    func configureDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
    }

    func setTest(_ viewType: ContentViewType) {
        self.viewType = viewType

        tableView.reloadData()

        switch viewType {
        case .default:
            titleLabel.text = "나의 단어"
        default:
            titleLabel.text = "오답 목록"
        }
    }

    @objc func didChangeHighlights() {
        self.highlightings = HighlightManager.share.getHighlights()
        self.filteredHighlightings = highlightings
        self.tableView.reloadData()
    }
}

extension RightSlideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewType {
        case .default:
            return filteredHighlightings.count
        case .result:
            return filteredResult?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewType {
        case .default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RightSlideMenuMainViewCell", for: indexPath) as? RightSlideMenuMainViewCell else { return UITableViewCell() }
            let highlight = filteredHighlightings[indexPath.row]
            cell.delegate = self
            cell.configure(highlight)

            return cell
        case .result:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RightSlideMenuResultViewCell", for: indexPath) as? RightSlideMenuResultViewCell else { return UITableViewCell() }
            let result = self.filteredResult?[indexPath.row]

            cell.answerLabel.text = result?.realAnswer
            cell.userAnswerLabel.text = result?.userAnswer

            return cell
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch viewType {
        case .default:
            return true
        case .result:
            return false
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { _, index in
            let highlighting = self.filteredHighlightings[index.row]
            self.highlightings.removeAll(where: { $0.startIndex == highlighting.startIndex })
            self.filteredHighlightings.remove(at: index.row)
            self.tableView.deleteRows(at: [index], with: UITableView.RowAnimation.automatic)
            self.delegate?.didDelete(highlight: highlighting)
        }
        return [deleteAction]
    }
}

extension RightSlideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewType {
        case .result:
            return 88.0
        default:
            return 55.0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        delegate?.didSelect(highlight: filteredHighlightings[indexPath.row])
    }
}

extension RightSlideMenuViewController: RightSlideMenuMainViewCellDelegate {
    func toggleStar(_ highlight: Highlight) {
        var toggled = highlight
        toggled.isImportant = toggled.isImportant == 0 ? 1: 0
        delegate?.didChange(highlight: toggled)
    }
}

extension RightSlideMenuViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textDidChanged(string)
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textDidChanged("")
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textDidChanged("")
        return true
    }

    func textDidChanged(_ string: String) {
        let text = textField.text ?? ""
        switch viewType {
        case .result:
            if text.isEmpty {
                filteredResult = result?.result
            } else {
                filteredResult = result?.result?.filter({ $0.realAnswer?.contains(text) ?? false })
            }
        default:
            if text.isEmpty {
                filteredHighlightings = highlightings
            } else {
                let text = textField.text ?? ""
                filteredHighlightings = highlightings.filter({
                    $0.content?.contains(text + string) ?? false })
            }
        }

        tableView.reloadData()
    }
}
