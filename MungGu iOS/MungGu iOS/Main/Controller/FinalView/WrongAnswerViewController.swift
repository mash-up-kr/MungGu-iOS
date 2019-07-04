//
//  WrongAnswerViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class WrongAnswerViewController: UIViewController {

    // TODO: testView 이름 바꿀 것
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBAction func goBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 1.0, animations: {
            self.testView.alpha = 0
            self.textView.alpha = 1.0
        }) { _ in
            self.testView.isHidden = true
        }
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
