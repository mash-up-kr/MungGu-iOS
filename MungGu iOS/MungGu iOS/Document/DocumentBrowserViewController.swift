//
//  DocumentBrowserViewController.swift
//  Document Based App template
//
//  Created by Daeyun Ethan on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

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

        let storyBoard = UIStoryboard(name: "Document", bundle: nil)
        guard let documentViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentViewController") as? DocumentViewController else {
            fatalError("Couldn't present document")
        }
        documentViewController.document = Document(fileURL: documentURL)

        present(documentViewController, animated: true, completion: nil)
    }

    @objc private func actionSelect(_ sender: UIButton) {

    }

    @objc private func actionCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
