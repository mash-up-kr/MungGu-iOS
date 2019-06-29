//
//  DetailViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UISplitViewControllerDelegate{
    
    @IBOutlet weak var textView: UITextView!
    @IBAction func expandBtn(_ sender: Any) {
        self.splitViewController?.delegate = self
        
        let primaryHidden = splitViewController?.preferredDisplayMode ?? .primaryHidden
        splitViewController?.preferredDisplayMode = primaryHidden == .allVisible ? .primaryHidden : .allVisible
    }
    
    var file:File? {
        didSet {
            refreshUI()
        }
    }
    
    func refreshUI() {
        loadViewIfNeeded()
        textView?.text = file?.content
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension DetailViewController: MasterViewControllerDelegate {
    func didselect(with data: File) {
        textView.text = data.content
    }
}
