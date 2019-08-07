//
//  RightSlideMenuViewController.swift
//  MungGu iOS
//
//  Created by Cloud on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class RightSlideMenuViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var firstView: UIView!
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties
    var filteredFiles = [File]()

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
//        filteredFiles = files
        view.endEditing(true)
        configureDelegate()
    }

    // MARK: - Handlers
    func configureDelegate() {
        tbView.delegate = self
        tbView.dataSource = self
        searchBar.delegate = self
    }
}

extension RightSlideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RightSlideMenuTableViewCell", for: indexPath) as? RightSlideMenuTableViewCell else { return UITableViewCell() }
        let file = filteredFiles[indexPath.row]
        cell.cellLabel.text = file.title
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { _, index in
            self.filteredFiles.remove(at: index.row)
            self.tbView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        return [deleteAction]
    }
}

extension RightSlideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}

extension RightSlideMenuViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            guard !searchText.isEmpty else {
//                filteredFiles = files
                tbView.reloadData()
                return
            }
//            filteredFiles = files.filter({ file -> Bool in
//                file.title.contains(searchText)
//            })
            tbView.reloadData()
    }
}
