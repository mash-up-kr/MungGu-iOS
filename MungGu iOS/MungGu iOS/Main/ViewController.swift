//
//  ViewController.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

    @IBAction private func actionShowDocument(_ sender: UIButton) {
        performSegue(withIdentifier: "DocumentSegue", sender: nil)
    }
}
