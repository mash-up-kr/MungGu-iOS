//
//  TestMenuViewController.swift
//  MungGu iOS
//
//  Created by Cloud on 08/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation
import UIKit

class ResultMenuViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var tbView: UITableView!

    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initDelegate()
    }

    // MARK: Handlers
    func initDelegate() {
        tbView.dataSource = self
        tbView.delegate = self
    }
}

extension ResultMenuViewController: UITableViewDelegate {

}

extension ResultMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ResultMenuTableViewCell else { return UITableViewCell() }
        cell.wrongLabel.text = " 틀린거 "
        cell.correctLabel.text = " 고친거 "
        return cell

    }

}
