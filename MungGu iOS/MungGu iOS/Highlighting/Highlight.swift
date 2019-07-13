//
//  Highlight.swift
//  MungGu iOS
//
//  Created by juhee on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

struct Highlight {
    var start: UITextPosition?
    var end: UITextPosition?
    var range: NSRange
    var text: String
    var type: HighlightType
}

struct HighlightData {
    var attributedString: NSAttributedString
    var highlightings: [Highlight]
}
