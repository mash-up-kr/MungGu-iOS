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

    @IBOutlet weak var someView: UIView!
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2.0, animations: {
            self.someView.alpha = 0
        }) { _ in
            self.view.removeFromSuperview()
            self.performSegue(withIdentifier: "result", sender: self)
        }
    }

    }
    // MARK: - Handlers
