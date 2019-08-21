//
//  HighlightTextViewDelegate.swift
//  MungGu iOS
//
//  Created by juhee on 13/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

protocol HighlightingTextViewDelegate: class {
    func colorFor(highlightMode: HighlightType) -> UIColor
    func didAdd(_ highlight: Highlight)
    func didRemove(_ highlight: Highlight)
    func didTap(_ highlight: Highlight)
    func didChange(state: HighlightingTextViewState)
}

extension HighlightingTextViewDelegate {
    func colorFor(highlightMode: HighlightType) -> UIColor {
        switch highlightMode {
        case .general:
            return .lightPeach
        case .imortant:
            return .blush
        }
    }

}
