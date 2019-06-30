//
//  DetailMenuViewController.swift
//  MungGu iOS
//
//  Created by Cloud on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class DetailMenuController: UIViewController {

    @IBOutlet weak var tbView: UITableView!
    var list = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegate()
    }

    func configureDelegate() {
        tbView.delegate = self
        tbView.dataSource = self
    }
}

extension DetailMenuController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.configureCell(list)
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { _, index in
            self.list.remove(at: index.row)
            self.tbView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        return [deleteAction]
    }
}

extension DetailMenuController: UITableViewDelegate {

}
