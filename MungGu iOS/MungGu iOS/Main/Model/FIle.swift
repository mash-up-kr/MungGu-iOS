//
//  FIle.swift
//  MungGu iOS
//
//  Created by 안예림 on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation

struct File {
    var title: String
    var content: String
    var date: String?
}

extension File {
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}
