//
//  MasterViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

protocol FilesViewControllerDelegate: class {
    func didSelected(with: FileData)
}

class FileListViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.layer.cornerRadius = 3.0
        }
    }
    @IBOutlet weak var filesTableView: UITableView!

    // MARK: - Properties
    private let fileTableViewCellIdentifier: String = "file_table_cell"
    private var filteredFiles: [FileData] = []
    private var files: [FileData] = []
    weak var delegate: FilesViewControllerDelegate?

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

        setUpSearchBar()
        DocumentDataManager.share.fetchDocument()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUpdate()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func checkUpdate() {
        DispatchQueue.global().async {
            guard let appStoreVersion = DeviceManager.getAppStoreVersion(),
                let currentVersion = DeviceManager.appVersionString else {
                    assertionFailure("Couldn't load app version")
                    return
            }

            if currentVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
    }

    private func showAlert() {
        let alertController = UIAlertController(title: "업데이트", message: "필수 업데이트가 있습니다. 업데이트하시겠습니까?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in

            if let url = URL(string: "itms-apps://itunes.apple.com/kr/app/apple-store/1479335828"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { opened in
                    if opened {
                        print("App Store Opened")
                    }
                    exit(-1)
                }
            }
        }))
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Handlers
    private func setUpSearchBar() {
        textField.delegate = self
    }

    @objc private func didChangedDocumentCount(_ notification: Notification) {
        files = DocumentDataManager.share.getDocument()
        filteredFiles = DocumentDataManager.share.getDocument()

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.textField.text = nil
            self.filesTableView.reloadData()
        }
    }
}

extension FileListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)

         let fileData = filteredFiles[indexPath.row]
         delegate?.didSelected(with: fileData)
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

extension FileListViewController: UITextFieldDelegate {
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
        if let text = textField.text, text.isEmpty {
            filteredFiles = files
        } else {
            let text = textField.text ?? ""
            filteredFiles = files.filter({ $0.name?.contains(text + string) ?? false })
        }
        filesTableView.reloadData()
    }
}
