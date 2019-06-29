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
    }

    private var startPosition: UITextPosition?
    private var endPosition: UITextPosition?
    private var shouldBeHighlight: Bool = false

    @IBOutlet private weak var textView: UITextView!

    @IBAction private func didTapTextView(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self.textView)
        let position = self.textView.closestPosition(to: point)
        self.endPosition = position
        if sender.state == .began,
            let startPosition = position {
            self.startPosition = startPosition
            self.checkHighlight(position: startPosition)
        } else if sender.state == .changed {
            if let start = self.startPosition,
                let end = self.endPosition {
                let textStorage = self.textView.textStorage
                let range = self.rangeOf(textView, start: start, end: end)
                self.textView.attributedText.enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { _, range, _ in
                    if self.shouldBeHighlight {
                        textStorage.addAttribute(.backgroundColor, value: UIColor.lightPeach, range: range)
                    } else {
                        textStorage.removeAttribute(.backgroundColor, range: range)
                    }
                }
            }
        }
    }

    private func rangeOf(_ textView: UITextView, start: UITextPosition, end: UITextPosition) -> NSRange {
        let compareResult = textView.compare(start, to: end)
        let length = textView.offset(from: start, to: end)
        switch compareResult {
        case .orderedAscending:
            let location = textView.offset(from: textView.beginningOfDocument, to: start)
            return NSRange(location: location - 1, length: length + 1)
        case .orderedDescending:
            let location = textView.offset(from: textView.beginningOfDocument, to: end)
            return NSRange(location: location, length: length * -1)
        case .orderedSame:
            return NSRange()
        }
    }

    private func checkHighlight(position start: UITextPosition) {
        guard let end: UITextPosition = self.textView.position(from: start, offset: 1) else {
            return
        }
        let range = self.rangeOf(self.textView, start: start, end: end)
        self.textView.attributedText.enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { attributes, _, _ in
            self.shouldBeHighlight = attributes[.backgroundColor] == nil
        }
    }

}
