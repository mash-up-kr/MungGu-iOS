//
//  PDFViewController.swift
//  MungGu iOS
//
//  Created by juhee on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let pdf = PDFContent(fileName: "sample")
        self.navigationItem.title = pdf.fileName
        self.textView.text = pdf.readPDF()
        self.textView.setupHighlightingGestures()
    }
    private var isTest: Bool = false

    @IBOutlet private weak var textView: HighlightingTextView!
    @IBAction private func didTapToggleButton(_ sender: UIButton) {
        self.isTest.toggle()
        self.isTest ? self.textView.hideHighlightedText() : self.textView.showHighlightedText()
    }

}
