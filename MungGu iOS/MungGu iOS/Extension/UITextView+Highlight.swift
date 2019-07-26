//
//  UITextView+Highlight.swift
//  MungGu iOS
//
//  Created by juhee on 26/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

extension UITextView {
    func makeHighlight(range: NSRange, start: UITextPosition, end: UITextPosition) -> Highlight {
        let content = self.textStorage.attributedSubstring(from: range).string

        let startIndex = offset(from: beginningOfDocument, to: start)
        let endIndex = offset(from: beginningOfDocument, to: end)

        return Highlight(id: nil, fileId: nil, startIndex: startIndex, endInex: endIndex, content: content, type: nil, isImportant: nil)
    }

    func rangeOf(start: UITextPosition, end: UITextPosition) -> NSRange {
        let compareResult = self.compare(start, to: end)
        let length = self.offset(from: start, to: end)
        switch compareResult {
        case .orderedAscending:
            let location = self.offset(from: self.beginningOfDocument, to: start)
            return NSRange(location: location - 1, length: length + 1)
        case .orderedDescending:
            let location = self.offset(from: self.beginningOfDocument, to: end)
            return NSRange(location: location, length: length * -1)
        case .orderedSame:
            return NSRange()
        }
    }

}
