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
}

class RightSlideMenuViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var containerView: UIView!
    @IBOutlet var firstView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Properties

    weak var delegate: RightSlideMenuViewControllerDelegate?
    var viewType: ContentViewType = .default
    var highlightings: [Highlight] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Init

    deinit {
        NotificationCenter.default.removeObserver(self, name: DocumentDataManager.NotificationName.documentCountDidChangedNotification, object: nil)
    }

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        view.endEditing(true)
        configureDelegate()

        NotificationCenter.default.addObserver(self, selector: #selector(didChangeHighlights), name: HighlightManager.DidChangedHighlights, object: nil)
        self.highlightings = HighlightManager.share.getHighlights()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        switch viewType {
        case .default:
            containerView.isHidden = false
        default:
            containerView.isHidden = true
        }
    }

    // MARK: - Handlers
    func configureDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
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
        self.tableView.reloadData()
    }
}

extension RightSlideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highlightings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewType {
        case .result:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RightSlideMenuResultViewCell", for: indexPath) as? RightSlideMenuResultViewCell else { return UITableViewCell() }
            // answerLabel
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RightSlideMenuMainViewCell", for: indexPath) as? RightSlideMenuMainViewCell else { return UITableViewCell() }
            let highlight = highlightings[indexPath.row]
            cell.wordLabel.text = highlight.content
            cell.highlight = highlight
            cell.delegate = self
            return cell
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { _, index in
            self.highlightings.remove(at: index.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
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
    }
}

extension RightSlideMenuViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            guard !searchText.isEmpty else {
                tableView.reloadData()
                return
            }
            highlightings = highlightings.filter({ highlight -> Bool in
                highlight.content?.contains(searchText) ?? false
            })
            tableView.reloadData()
    }
}

extension RightSlideMenuViewController: RightSlideMenuMainViewCellDelegate {
    func toggleStar(_ highlight: Highlight) {
        guard let indexPath = highlightings.firstIndex(where: { $0.startIndex == highlight.startIndex && $0.endIndex == highlight.endIndex }) else {
            return
        }
        highlightings[indexPath].isImportant?.toggle()
        HighlightManager.share.highlights = self.highlightings
    }
}
