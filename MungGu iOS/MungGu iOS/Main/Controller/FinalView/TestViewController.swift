//
//  TestViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

protocol TestViewControllerDelegate: class {
    func didTap()
}

class TestViewController: UIViewController, UISplitViewControllerDelegate {

    weak var delegate: TestViewControllerDelegate?
    @IBAction func expandBtn(_ sender: Any) {
        self.splitViewController?.delegate = self

        let primaryHidden = splitViewController?.preferredDisplayMode ?? .primaryHidden
        splitViewController?.preferredDisplayMode = primaryHidden == .allVisible ? .primaryHidden : .allVisible
    }
    @IBAction func showResultBtn(_ sender: Any) {

        delegate?.didTap()
        let storyboard = UIStoryboard(name: "Test", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "wrongAnswer") as? WrongAnswerViewController {
            navigationController?.pushViewController(vc, animated: true)

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestViewController: MasterViewControllerDelegate {
    func didselect(with data: File) {

    }
}
