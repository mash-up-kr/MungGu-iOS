//
//  DocumentBrowserViewController.swift
//  Document Based App template
//
//  Created by Daeyun Ethan on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit
import PDFKit

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        allowsDocumentCreation = false
        allowsPickingMultipleItems = true

        let cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(actionCancel))

        additionalTrailingNavigationBarButtonItems = [cancelItem]
    }

    // MARK: UIDocumentBrowserViewControllerDelegate

    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        let newDocumentURL: URL? = nil

        // TODO: 의미가 있는 지 체크..
        if newDocumentURL != nil {
            importHandler(newDocumentURL, .move)
        } else {
            importHandler(nil, .none)
        }
    }

    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }

        presentDocument(at: sourceURL)
    }

    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {

        presentDocument(at: destinationURL)
    }

    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
    }

    // MARK: Document Presentation

    func presentDocument(at documentURL: URL) {
        DispatchQueue.global().async { [weak self] in
            let fileName = (documentURL.absoluteString.components(separatedBy: "/").last ?? "").removingPercentEncoding ?? ""

            let names = fileName.split(separator: ".")
            let firstName = names.first ?? ""
            let fileExtension = names.dropFirst()
            let setExtension = Set(fileExtension)
            let name = "\(firstName).\(setExtension.joined())"

            DocumentDataManager.share.fileName = name

            guard DocumentDataManager.share.canSave(name) else {
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(title: "이미 동일한 이름의 파일이 존재 합니다.", message: nil, preferredStyle: .alert, needOkay: false, okayAction: { [weak self] _ in
                        self?.actionCancel()
                    })
                }
                return
            }

            let document = Document(fileURL: documentURL)
            document.open { [weak self] success in
                guard success else { return }

                DispatchQueue.main.async { [weak self] in
                    self?.actionCancel()
                }
            }
        }
    }

    @objc private func actionSelect(_ sender: UIButton) {

    }

    @objc private func actionCancel(_ sender: UIButton? = nil) {
        dismiss(animated: true, completion: nil)
    }
}
