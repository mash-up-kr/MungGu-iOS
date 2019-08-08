//
//  FIle.swift
//  MungGu iOS
//
//  Created by 안예림 on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation

struct File {
    var id: String
    var title: String
    var content: String
    var date: String?
}

extension File {
    init(id: String, title: String, content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
}
