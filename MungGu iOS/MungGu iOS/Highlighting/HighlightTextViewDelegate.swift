//
//  HighlightTextViewDelegate.swift
//  MungGu iOS
//
//  Created by juhee on 13/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

protocol HighlightingTextViewDelegate: class {
    func colorFor(isImportant: Bool, state: HighlightingTextViewState) -> UIColor
    func didAdd(_ highlight: Highlight)
    func didRemove(_ highlight: Highlight)
    func didTap(_ highlight: Highlight)
    func didChange(state: HighlightingTextViewState)
}

extension HighlightingTextViewDelegate {
    func colorFor(isImportant: Bool, state: HighlightingTextViewState) -> UIColor {
        switch state {
        case .test:
            return isImportant ? .darkBlue : .iceBlue
        default:
            return isImportant ? .blush : .lightPeach
        }
    }

}
