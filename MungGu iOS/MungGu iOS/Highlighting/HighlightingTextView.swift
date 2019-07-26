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
            isGestureEnable = isHighlightingActive
        }
    }

    weak var highlighDelegate: HighlightingTextViewDelegate?

    var highlighType: HighlightType = .general
    var state: HighlightingTextViewState = .highlighting {
        didSet {
            self.highlighDelegate?.didChange(state: state)
        }
    }
    var isGestureEnable: Bool = false {
        didSet {
            if panGesture == nil || tapGestrue == nil {
                setupHighlightingGestures()
            }
            panGesture?.isEnabled = isGestureEnable
            tapGestrue?.isEnabled = isGestureEnable
        }
    }

    func loadData(content: String, from data: [Highlight], state: HighlightingTextViewState = .highlighting) {
        self.state = state
        text = content
        data.forEach { highlight in
            addHighlighting(color: highlightColor, range: highlight.range)
        }
        highlightings = data
    }

    func clear() {
        attributedText = nil
        text = nil
        highlightings = []
        currentRange = nil
        panGesture = nil
        tapGestrue = nil
        isGestureEnable = false
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

    private var startPoint: CGPoint = .zero
    private var endPoint: CGPoint = .zero
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
        if sender.state != .began && point.x <= startPoint.x {
            return
        }

        if sender.state != .began {
            endPoint.y = startPoint.y
            endPoint.x = max(point.x, endPoint.x)
        }

        let position = self.closestPosition(to: point)
        self.tapGestrue?.isEnabled = false

        switch sender.state {
        case .began:
            startPoint = point
        case .changed:
            if let start = closestPosition(to: startPoint),
                let end = closestPosition(to: endPoint) {
                let range = self.rangeOf(start: start, end: end)
                self.addHighlighting(color: self.highlightColor, range: range)
                self.currentRange = range
            }
        case .ended:
            self.tapGestrue?.isEnabled = true
            if let range = self.currentRange,
                let start = closestPosition(to: startPoint),
                let end = closestPosition(to: endPoint) {
                let highlight = makeHighlight(range: range, start: start, end: end)
                self.highlightings.append(highlight)
                self.highlighDelegate?.didAdd(highlight)
            }
            self.currentRange = nil
            self.startPoint = .zero
            self.endPoint = .zero
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

}

extension HighlightingTextView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
