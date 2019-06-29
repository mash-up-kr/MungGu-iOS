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
    private var currentRange: NSRange?
    private var highlightedRanges: [NSRange] = []
    private var isTest: Bool = false

    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private var panGesture: UIPanGestureRecognizer!

    @IBAction private func didPanTextView(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self.textView)
        let position = self.textView.closestPosition(to: point)
        self.endPosition = position

        switch sender.state {
        case .began:
            self.startPosition = position
        case .changed:
            if let start = self.startPosition,
                let end = self.endPosition {
                let range = self.rangeOf(textView, start: start, end: end)
                self.addHighlighting(range: range)
            }
        case .ended:
            self.panGesture.isEnabled = true
            if self.currentRange != nil {
                self.highlightedRanges.append(currentRange!)
                self.currentRange = nil
            }
        default:
            ()
        }
    }

    @IBAction private func didTapTextView(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.textView)
        if let position = self.textView.closestPosition(to: point) {
            self.removeHighlighting(position: position)
        }
    }

    @IBAction private func didTapToggleButton(_ sender: UIButton) {
        self.isTest.toggle()
        self.highlightedRanges.forEach { range in
            let textStorage = self.textView.textStorage
            self.textView.attributedText.enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { _, range, _ in
                if self.isTest {
                    textStorage.addAttribute(.foregroundColor, value: UIColor.lightPeach, range: range)
                } else {
                    textStorage.removeAttribute(.foregroundColor, range: range)
                }
            }
        }
    }

    private func addHighlighting(range: NSRange) {
        let textStorage = self.textView.textStorage
        self.textView.attributedText.enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { _, range, _ in
            textStorage.addAttribute(.backgroundColor, value: UIColor.lightPeach, range: range)
        }
        self.currentRange = range
    }

    private func removeHighlighting(position: UITextPosition) {
        let location = self.textView.offset(from: textView.beginningOfDocument, to: position)
        var rangeAmount = 0
        self.highlightedRanges.removeAll(where: { range -> Bool in
            if range.contains(location) {
                self.textView.textStorage.removeAttribute(.backgroundColor, range: range)
                rangeAmount += 1
                return true
            }
            return false
        })
        if rangeAmount != 0 {
            textView.setNeedsDisplay()
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
        self.textView.attributedText.enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { _, _, _ in
//            self.shouldBeHighlight = attributes[.backgroundColor] == nil
        }
    }

}
