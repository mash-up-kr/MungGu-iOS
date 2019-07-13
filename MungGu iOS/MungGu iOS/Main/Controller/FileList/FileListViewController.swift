//
//  MasterViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

protocol FilesViewControllerDelegate: class {
    func didSelected(with: File)
}

class FileListViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var filesTableView: UITableView!

    // MARK: - Properties
    private let fileTableViewCellIdentifier: String = "file_table_cell"
    private var filteredFiles = [File]()
    weak var delegate: FilesViewControllerDelegate?

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        filesTableView.delegate = self
        filesTableView.dataSource = self
        view.endEditing(true)
        filteredFiles = UIViewController.sampleFiles
        setUpSearchBar()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Handlers
    private func setUpSearchBar() {
        mySearchBar.delegate = self
    }

}

extension FileListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredFiles = UIViewController.sampleFiles
        } else {
            filteredFiles = UIViewController.sampleFiles.filter { $0.title.contains(searchText) }
        }
        filesTableView.reloadData()
    }

}

extension FileListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        let selectedData = filteredFiles[indexPath.row]
        delegate?.didSelected(with: selectedData)
    }

}

extension FileListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: fileTableViewCellIdentifier, for: indexPath) as? FileTableViewCell else {
            preconditionFailure("\(#function) - dequeue fail with identifier : \(fileTableViewCellIdentifier)")
        }
        // FIXME
        let file = filteredFiles[indexPath.row]
        cell.titleLabel.text = file.title
        return cell
    }

}
