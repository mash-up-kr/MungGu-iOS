//
//  DocumentDataManager.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 13/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation

class DocumentDataManager {
    static let identifier = "Documents"
    static let share = DocumentDataManager()

    struct NotificationName {
        static let documentCountDidChangedNotification = Notification.Name(rawValue: "documentCountDidChanged")
    }

    // TODO: 중복 데이트 체크 필요.
    private var documents: [String] = []

    private var filePathURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private init() {
        fetchDocument()
    }

    func makeURL(_ fileName: String) -> URL {
        return filePathURL.appendingPathComponent("\(fileName)")
    }

    func fetchDocument() {
        if let documents = UserDefaults.standard.array(forKey: DocumentDataManager.identifier) as? [String] {
            self.documents = documents
        }
    }

    func getDocument() -> [String] {
        return documents
    }

    func canSave(_ fileName: String) -> Bool {
        if documents.contains(fileName) {
            return false
        }
        return true
    }

    func saveDocument(_ fileName: String) {
        documents.append(fileName)
        UserDefaults.standard.set(documents, forKey: DocumentDataManager.identifier)

        NotificationCenter.default.post(name: NotificationName.documentCountDidChangedNotification, object: nil)
    }
}
