//
//  DetailViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UISplitViewControllerDelegate{
    
    @IBAction func expandBtn(_ sender: Any) {
        self.splitViewController?.delegate = self
        
        let primaryHidden = splitViewController?.preferredDisplayMode ?? .primaryHidden
        splitViewController?.preferredDisplayMode = primaryHidden == .allVisible ? .primaryHidden : .allVisible
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
