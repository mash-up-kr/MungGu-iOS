//
//  Model.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 13/07/2019.
//  Copyright © 2019 Mash-Up. All rights reserved.
//

import Foundation

enum HightlightType: String, Codable {
    case word = "WORD"
}

struct AddDevice: Codable {
    let deviceKey: String?
}

struct DeviceInfo: Codable {
    let id: Int?
    let deviceKey: String?
    let createdAt: String?
}

struct FileData: Codable {
    let id: Int?
    let name: String?
}

struct Hightlight: Codable {
    let id: Int?
    let fileId: Int?
    let startIndex: Int?
    let endInex: Int?
    let content: String?
    let type: HightlightType?
    let isImportant: Bool?
}

struct Quiz: Codable {
    let startIndex: Int?
    let endIndex: Int?
}

struct Answer: Codable {
    let userAnswer: String?
}
