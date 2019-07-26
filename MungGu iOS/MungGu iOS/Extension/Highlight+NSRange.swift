//
//  Highlight+NSRange.swift
//  MungGu iOS
//
//  Created by juhee on 27/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation

extension Highlight {
    var range: NSRange {
        guard let start = startIndex,
            let end = endInex else {
                preconditionFailure("start end index couldn't be nil")
        }

        return NSRange(location: start - 1, length: end - start + 1)
    }

}
