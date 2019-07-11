//
//  Test.swift
//  MungGu iOS
//
//  Created by Cloud on 09/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation
import UIKit

class TestViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var fileLabel: UILabel!

    // MARK: - Properties
    var fileTitle: String?

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        fileLabel.text = fileTitle
        print(fileTitle)
    }

    // MARK: - Handlers

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController = segue.destination as? ResultContainerViewController
        resultViewController?.fileTitle = self.fileTitle
    }

    // MARK: - IBActions
    @IBAction private func exitButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
