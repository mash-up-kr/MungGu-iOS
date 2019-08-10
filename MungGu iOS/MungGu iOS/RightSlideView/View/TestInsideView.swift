//
//  TestInsideView.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 10/08/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class TestInsideView: UIView {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "RightSlideMenuTestViewCell", bundle: nil), forCellReuseIdentifier: "RightSlideMenuTestViewCell")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInitializer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInitializer()
    }

    func commonInitializer() {
        guard let view = Bundle.main.loadNibNamed("TestInsideView", owner: self, options: nil)?.first as? UIView else {
            preconditionFailure("Couldn't load nib")
        }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
    }
}

extension TestInsideView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RightSlideMenuTestViewCell", for: indexPath) as? RightSlideMenuTestViewCell else { return UITableViewCell() }
        return cell
    }
}

extension TestInsideView: UITableViewDelegate {

}
