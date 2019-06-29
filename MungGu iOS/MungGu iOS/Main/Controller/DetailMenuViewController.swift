//
//  MenuViewController.swift
//  MungGu iOS
//
//  Created by Cloud on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class DetailMenuViewController: UIViewController {

    // MARK: - Propertise
    @IBOutlet weak var tbView: UITableView!
    var arr = [String]()

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        initDelegate()
    }

    // MARK: - Handlers
    func initDelegate() {
        tbView.dataSource = self
        tbView.delegate = self
    }
}

extension DetailMenuViewController: UITableViewDelegate {
}

extension DetailMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.configureCell(arr)
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { _, index in
            self.arr.remove(at: index.row)
            self.tbView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        return [deleteAction]
    }
}
