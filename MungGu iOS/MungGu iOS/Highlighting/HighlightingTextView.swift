//
//  HighlightingText.swift
//  MungGu iOS
//
//  Created by juhee on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class HighlightingTextView: UITextView {

    @IBInspectable var isHighlightingActive: Bool = true {
        didSet {
            self.panGesture?.isEnabled = self.isHighlightingActive
            self.tapGestrue?.isEnabled = self.isHighlightingActive
        }
    }

    weak var highlighDelegate: HighlightingTextViewDelegate?

    var highlightData: HighlightData {
        return HighlightData(attributedString: self.attributedText, highlightings: self.highlightings)
    }
    var highlighType: HighlightType = .general
    var state: HighlightingTextViewState = .highlighting {
        didSet {
            self.highlighDelegate?.didChange(state: self.state)
        }
    }
    var isGestureEnable: Bool = false {
        didSet {
            if self.panGesture == nil || self.tapGestrue == nil {
                self.setupHighlightingGestures()
            }
            self.panGesture?.isEnabled = self.isGestureEnable
            self.tapGestrue?.isEnabled = self.isGestureEnable
        }
    }

    func loadData(from data: HighlightData, state: HighlightingTextViewState, isGestureEnable: Bool = false) {
        self.state = state
        attributedText = data.attributedString
        highlightings = data.highlightings

    }

    func showHighlightedText() {
        self.highlightings.forEach { highlight in
            self.attributedText.enumerateAttributes(in: highlight.range, options: .longestEffectiveRangeNotRequired) { _, range, _ in
                self.textStorage.removeAttribute(.foregroundColor, range: range)
            }
        }
    }

    func hideHighlightedText() {
        self.highlightings.forEach { highlight in
            self.attributedText.enumerateAttributes(in: highlight.range, options: .longestEffectiveRangeNotRequired) { _, range, _ in
                self.textStorage.removeAttribute(.foregroundColor, range: range)
                self.textStorage.addAttribute(.foregroundColor, value: self.highlightColor, range: range)
            }
        }
    }

    private var startPosition: UITextPosition?
    private var endPosition: UITextPosition?
    private var currentRange: NSRange?
    private (set) var highlightings: [Highlight] = []

    private var panGesture: UIPanGestureRecognizer?
    private var tapGestrue: UITapGestureRecognizer?

    private var highlightColor: UIColor {
        return self.highlighDelegate?.colorFor(highlightMode: self.highlighType) ?? self.highlighType.defaultColor
    }

    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        guard self.state != .test else {
            return
        }
        let point = sender.location(in: self)
        let position = self.closestPosition(to: point)
        self.endPosition = position
        self.tapGestrue?.isEnabled = false

        switch sender.state {
        case .began:
            self.startPosition = position
        case .changed:
            if let start = self.startPosition,
                let end = self.endPosition {
                let range = self.rangeOf(self, start: start, end: end)
                self.addHighlighting(color: self.highlightColor, range: range)
                self.currentRange = range
            }
        case .ended:
            self.tapGestrue?.isEnabled = true
            if let range = self.currentRange {
                let text = self.textStorage.attributedSubstring(from: range).string
                let highlight = Highlight(start: startPosition, end: endPosition, range: range, text: text, type: self.highlighType)
                self.highlightings.append(highlight)
                self.highlighDelegate?.didAdd(highlight)
                self.currentRange = nil
            }
        default:
            ()
        }
    }

    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        if let position = self.closestPosition(to: point) {
            if state != .test {
                self.removeHighlighting(position: position)
            } else if let highlighting = highlightAt(position: position) {
                self.highlighDelegate?.didTap(highlighting)
            }
        }
    }

    private func setupHighlightingGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGesture)
        self.panGesture = panGesture
        let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.addGestureRecognizer(tapGestrue)
        self.tapGestrue = tapGestrue
    }

    private func highlightAt(position: UITextPosition) -> Highlight? {
        let location = self.offset(from: self.beginningOfDocument, to: position)
        return self.highlightings.first { $0.range.contains(location) }
    }

    private func addHighlighting(color: UIColor, range: NSRange) {
        let textStorage = self.textStorage
        self.attributedText.enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { _, range, _ in
            textStorage.addAttribute(.backgroundColor, value: color, range: range)
        }
    }

    private func removeHighlighting(position: UITextPosition) {
        let location = self.offset(from: self.beginningOfDocument, to: position)
        var matchedCount = 0
        self.highlightings.removeAll(where: { highlight -> Bool in
            if highlight.range.contains(location) {
                self.textStorage.removeAttribute(.backgroundColor, range: highlight.range)
                self.textStorage.removeAttribute(.foregroundColor, range: highlight.range)
                matchedCount += 1
                self.highlighDelegate?.didRemove(highlight)
                return true
            }
            return false
        })
        if matchedCount > 0 {
            self.setNeedsDisplay()
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

}
