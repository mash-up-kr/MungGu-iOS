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
    private var filteredFiles: [FileData] = []
    weak var delegate: FilesViewControllerDelegate?

    private var data: [FileData] {
        return DocumentDataManager.share.getDocument()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: DocumentDataManager.NotificationName.documentCountDidChangedNotification, object: nil)
    }

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(didChangedDocumentCount), name: DocumentDataManager.NotificationName.documentCountDidChangedNotification, object: nil)

        filesTableView.delegate = self
        filesTableView.dataSource = self
        view.endEditing(true)

        filteredFiles = data

        setUpSearchBar()

        let service = Service.file(method: .get, data: nil)
        Provider.request(service, completion: { (data: FilesResult) in
            print("\(data)")
        }, failure: { _ in

        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Handlers
    private func setUpSearchBar() {
        mySearchBar.delegate = self
    }

    @objc private func didChangedDocumentCount(_ notification: Notification) {
        filteredFiles = data
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.mySearchBar.text = nil
            self.filesTableView.reloadData()
        }
    }
}

extension FileListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredFiles = data
        } else {
            filteredFiles = data.filter({ $0.name?.contains(searchText) ?? false })
        }
        filesTableView.reloadData()
    }
}

extension FileListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
//        let selectedData = filteredFiles[indexPath.row]
//        delegate?.didSelected(with: selectedData)

         let fileData = filteredFiles[indexPath.row]
         let content = DocumentDataManager.share.readPDF(fileData.name ?? "")
         let file = File(title: fileData.name ?? "", content: content)

         delegate?.didSelected(with: file)
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
        cell.titleLabel.text = file.name
        return cell
    }
}
