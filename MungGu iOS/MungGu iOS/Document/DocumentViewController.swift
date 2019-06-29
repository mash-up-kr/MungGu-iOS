//
//  DocumentViewController.swift
//  Document Based App template
//
//  Created by Daeyun Ethan on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    @IBOutlet weak var documentNameLabel: UILabel!
    @IBOutlet weak var documentContentLabel: UILabel!

    var document: UIDocument?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        document?.open(completionHandler: { success in
            if success {
                self.documentNameLabel.text = self.document?.fileURL.lastPathComponent
//                self.documentContentLabel.text = try? self.document?.contents(forType: ".txt") as? String
            } else {
            }
        })
    }

    @IBAction private func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
}
