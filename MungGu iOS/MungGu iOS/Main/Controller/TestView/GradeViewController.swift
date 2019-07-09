//
//  DetailGradeViewController.swift
//  MungGu iOS
//
//  Created by Cloud on 08/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation
import UIKit

class GradeViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var gradeLabel: UIButton!

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Handlers
    @IBAction func exitButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
