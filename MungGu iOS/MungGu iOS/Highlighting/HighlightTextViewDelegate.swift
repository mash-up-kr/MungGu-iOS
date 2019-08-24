//
//  HighlightTextViewDelegate.swift
//  MungGu iOS
//
//  Created by juhee on 13/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

protocol HighlightingTextViewDelegate: class {
    func colorFor(result: QuizMarkResult) -> (foreground: UIColor, background: UIColor)
    func colorFor(isImportant: Int, state: HighlightingTextViewState) -> UIColor
    func didAdd(_ highlight: Highlight)
    func didRemove(_ highlight: Highlight)
    func didTap(_ highlight: Highlight)
    func didChange(state: HighlightingTextViewState)
}

extension HighlightingTextViewDelegate {
    func colorFor(result: QuizMarkResult) -> (foreground: UIColor, background: UIColor) {
        switch result.mark {
        case 0:
            return (.white, .tomatoRed)
        default:
            return (.lightishBlue, .clear)
        }
    }
    func colorFor(isImportant: Int, state: HighlightingTextViewState) -> UIColor {
        switch state {
        case .test:
            return isImportant == 1 ? .darkBlue : .iceBlue
        default:
            return isImportant == 1 ? .blush : .lightPeach
        }
    }

}
