//
//  Model.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 13/07/2019.
//  Copyright © 2019 Mash-Up. All rights reserved.
//

import Foundation

enum BlankType: String, Codable {
    case word = "WORD"
    case sentence = "SENTENCE"
}

struct AddDevice: Codable {
    let deviceKey: String?
}

struct DeviceInfo: Codable {
    let id: Int?
    let deviceKey: String?
    let createdAt: String?
}

struct AddFile: Codable {
    let name: String?
}

struct FileData: Codable {
    let id: Int?
    let name: String?
}

struct Highlight: Codable {
    let id: Int?
    let fileId: Int?

    let startIndex: Int?
    let endIndex: Int?
    let content: String?
    let isImportant: Bool?

    let type: BlankType?
}

struct Quiz: Codable {
    let startIndex: Int?
    let endIndex: Int?
}

struct Answer: Codable {
    let userAnswer: String?
}

struct ErrorData: Decodable {
    let code: Int?
    let msg: String?
    let timestamp: String?
}

// TODO: API 변경 필요
struct FilesResult: Decodable {
    let files: [FileData]
}

struct QuizzesResult: Decodable {
    let quizzes: [Quiz]
}

struct QuizzesRequest: Encodable {
    let answers: [Answer]
}

struct QuizzesResponse: Decodable {
    let score: Int?
    let perfectScore: Int?
    let results: [QuizMarkResult]?
}

struct QuizMarkResult: Decodable {
    let userAnswer: String?
    let realAnswer: String?
    let mark: Int?
}

// Request, Response 공통
struct Highlights: Codable {
    let highlights: [Highlight]
}
