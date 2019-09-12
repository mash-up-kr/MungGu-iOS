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

    var state: HighlightingTextViewState = .highlighting {
        didSet {
            highlighDelegate?.didChange(state: state)
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

    func loadData(content: String, from data: [Highlight]) {
        text = content
        setTextView()

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

    func updateTextView(from data: [Highlight]) {
        highlightings = []
        data.forEach { highlight in
            let updateColor = self.highlighDelegate?.colorFor(isImportant: highlight.isImportant ?? 0, state: self.state) ?? highlightColor
            addHighlighting(color: updateColor, range: highlight.range)
        }
        highlightings = data
    }

    // 하나의 highlight 에 대해 업데이트 할 때 사용하세요.
    func updateTextView(with highlight: Highlight, changedColor: UIColor? = nil) {
        var updateColor = self.highlighDelegate?.colorFor(isImportant: highlight.isImportant ?? 0, state: self.state) ?? highlightColor
        if let color = changedColor {
            updateColor = color
        }

        var updateClosures: [((NSRange) -> Void)] = []
        updateClosures.append { range in
            self.textStorage.removeAttribute(.foregroundColor, range: range)
            self.textStorage.removeAttribute(.backgroundColor, range: range)
            self.textStorage.addAttribute(.backgroundColor, value: updateColor, range: range)
        }

        if state != .highlighting {
            updateClosures.append { range in
                self.textStorage.addAttribute(.foregroundColor, value: updateColor, range: range)
            }
        }

        attributedText.enumerateAttributes(in: highlight.range, options: .longestEffectiveRangeNotRequired) { _, range, _ in
            updateClosures.forEach({ closure in
                closure(range)
            })
        }
    }

    // 하나의 highlight 에 대해 업데이트 할 때 사용하세요.
    func updateTextView(results: [QuizMarkResult]) {
        guard let delegate = highlighDelegate else { return }
        for index in 0..<results.count {
            let highlight = highlightings[index]
            let result = results[index]

            let updateColor = delegate.colorFor(result: result)

            attributedText.enumerateAttributes(in: highlight.range, options: .longestEffectiveRangeNotRequired) { _, range, _ in
                self.textStorage.removeAttribute(.foregroundColor, range: range)
                self.textStorage.removeAttribute(.backgroundColor, range: range)
                self.textStorage.addAttribute(.backgroundColor, value: updateColor.background, range: range)
                self.textStorage.addAttribute(.foregroundColor, value: updateColor.foreground, range: range)
            }
        }
    }

    func showHighlightedText() {
        highlightings.forEach { highlight in
            self.attributedText.enumerateAttributes(in: highlight.range, options: .longestEffectiveRangeNotRequired) { _, range, _ in
                self.textStorage.removeAttribute(.foregroundColor, range: range)
            }
        }
    }

    func hideHighlightedText() {
        highlightings.forEach { highlight in

            let updateColor = self.highlighDelegate?.colorFor(isImportant: highlight.isImportant ?? 0, state: self.state) ?? highlightColor
            attributedText.enumerateAttributes(in: highlight.range, options: .longestEffectiveRangeNotRequired) { _, range, _ in
                self.textStorage.removeAttribute(.foregroundColor, range: range)
                self.textStorage.addAttribute(.foregroundColor, value: updateColor, range: range)
            }
        }
    }

    func removeHighlight(_ highlight: Highlight) {
        var matchedCount = 0

        highlightings.removeAll(where: { highlighting -> Bool in

            if highlighting.startIndex == highlight.startIndex {
                self.textStorage.removeAttribute(.backgroundColor, range: highlight.range)
                self.textStorage.removeAttribute(.foregroundColor, range: highlight.range)
                matchedCount += 1
                return true
            }
            return false
        })

        if matchedCount > 0 {
            setNeedsDisplay()
        }
    }

    private var startPoint: CGPoint = .zero
    private var endPoint: CGPoint = .zero
    private var currentRange: NSRange?
    private (set) var highlightings: [Highlight] = []

    private var panGesture: UIPanGestureRecognizer?
    private var tapGestrue: UITapGestureRecognizer?

    private var highlightColor: UIColor {
        return highlighDelegate?.colorFor(isImportant: 0, state: state) ?? .lightPeach
    }

    private func setTextView() {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 25.0
        style.lineSpacing = 2.0
        let font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        let attributes = [NSAttributedString.Key.paragraphStyle: style,
                          NSAttributedString.Key.font: font]
        attributedText = NSAttributedString(string: attributedText.string, attributes: attributes)
    }

    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        guard state != .test, state != .result else {
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

        tapGestrue?.isEnabled = false

        switch sender.state {
        case .began:
            startPoint = point
        case .changed:
            if let start = closestPosition(to: startPoint),
                let end = closestPosition(to: endPoint) {
                guard let range = rangeOf(start: start, end: end) else {
                    currentRange = nil
                    return
                }

                addHighlighting(color: highlightColor, range: range)
                currentRange = range
            }
        case .ended:
            tapGestrue?.isEnabled = true
            if let range = currentRange,
                let start = closestPosition(to: startPoint),
                let end = closestPosition(to: endPoint) {
                let highlight = makeHighlight(range: range, start: start, end: end)
                highlightings.append(highlight)
                highlighDelegate?.didAdd(highlight)
            }
            currentRange = nil
            startPoint = .zero
            endPoint = .zero
        default:
            ()
        }
    }

    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        if let position = closestPosition(to: point) {
            if state != .test, state != .result {
                removeHighlighting(position: position)
            } else if let highlighting = highlightAt(position: position) {
                highlighDelegate?.didTap(highlighting)
            }
        }
    }

    private func setupHighlightingGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(panGesture)
        self.panGesture = panGesture
        let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        addGestureRecognizer(tapGestrue)
        self.tapGestrue = tapGestrue
    }

    private func highlightAt(position: UITextPosition) -> Highlight? {
        let location = offset(from: beginningOfDocument, to: position)
        return highlightings.first { $0.range.contains(location) }
    }

    private func addHighlighting(color: UIColor, range: NSRange) {
        let textStorage = self.textStorage
        attributedText.enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { _, range, _ in
            textStorage.addAttribute(.backgroundColor, value: color, range: range)
        }
    }

    private func removeHighlighting(position: UITextPosition) {
        let location = offset(from: beginningOfDocument, to: position)
        var matchedCount = 0
        self.highlightings.removeAll(where: { highlight -> Bool in
            if highlight.range.contains(location) {
                textStorage.removeAttribute(.backgroundColor, range: highlight.range)
                textStorage.removeAttribute(.foregroundColor, range: highlight.range)
                matchedCount += 1
                highlighDelegate?.didRemove(highlight)
                return true
            }
            return false
        })
        if matchedCount > 0 {
            setNeedsDisplay()
        }
    }

}

extension HighlightingTextView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
