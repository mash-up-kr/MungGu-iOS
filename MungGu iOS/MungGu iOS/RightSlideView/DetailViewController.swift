//
//  DetailViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UISplitViewControllerDelegate {

    // MARK: - IBOutlet
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var fileLabel: UILabel!

    // MARK: - Properties
    var hide = false
    var file: File? {
        didSet {
            refreshUI()
        }
    }
    weak var delegate: ContainerViewControllerDelegate?

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.endEditing(true)
        toggleButton.isHidden = true
    }

    // MARK: - Handlers
    func refreshUI() {
        loadViewIfNeeded()
        textView?.text = file?.content
    }

    func hideExpandButton() {
        if  hide {
            toggleButton.isHidden = true
        } else {
            toggleButton.isHidden = false
        }
        hide.toggle()
    }

    func hideToggleButton() {
        if hide {
            expandButton.isHidden = true
        } else {
            expandButton.isHidden = false
        }
        hide.toggle()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let testViewController = segue.destination as? TestViewController
        testViewController?.fileTitle = file?.title
    }

    // MARK: - IBActions
    @IBAction private func expandBtn(_ sender: UIButton) {
        hideExpandButton()
        self.splitViewController?.delegate = self
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            let primaryHidden = self.splitViewController?.preferredDisplayMode ?? .primaryHidden
            self.splitViewController?.preferredDisplayMode = primaryHidden == .allVisible ? .primaryHidden : .allVisible
        })
    }

    @IBAction private func toggleMenu(_ sender: UIButton) {
        hideToggleButton()
        sender.isSelected.toggle()
        delegate?.handleToggleMenu()
    }

    @IBAction private func goTest(_ sender: UIButton) {
    }

    @IBAction private func blindText(_ sender: UIButton) {
//        eyeButton.isSelected.toggle()
        performSegue(withIdentifier: "DocumentSegue", sender: nil)
    }

    @IBAction private func unwind(segue: UIStoryboardSegue) { }
}

extension DetailViewController: MasterViewControllerDelegate {
    func didselect(with data: File) {
        textView.text = data.content
        fileLabel.text = data.title
        file = data
    }
}

extension DetailViewController: ContainerViewControllerDelegate {
    func handleToggleMenu() {
        delegate?.handleToggleMenu()
    }
}
