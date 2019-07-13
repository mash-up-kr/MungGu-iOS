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

    // MARK: - Properties
    private var file: File!

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = file.title
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController = segue.destination as? ResultContainerViewController
        resultViewController?.fileTitle = file.title
    }

    func bind(_ file: File) {
        self.file = file
    }

    // MARK: - IBActions
    @IBAction private func exit(_ sender: Any) {
        let alertViewController = UIAlertController(.exitText)
        alertViewController.addAction(UIAlertAction(title: "종료", style: .destructive) { [weak self] _ in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        })
        alertViewController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }

}
