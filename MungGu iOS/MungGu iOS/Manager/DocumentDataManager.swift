//
//  DocumentDataManager.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 13/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation
import PDFKit

class DocumentDataManager {
    static let identifier = "Documents"
    static let share = DocumentDataManager()

    var fileName = ""

    struct NotificationName {
        static let documentCountDidChangedNotification = Notification.Name(rawValue: "documentCountDidChanged")
    }

    // TODO: 중복 데이트 체크 필요.
    private var files: [FileData] = []

    private var filePathURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private init() { }

    func makeURL(_ fileName: String) -> URL {
        return filePathURL.appendingPathComponent("\(fileName).pdf")
    }

    func fetchDocument() {

        let service = Service.file(method: .get, data: nil)
        Provider.request(service, completion: { (data: FilesResult) in
            self.files = data.files

            NotificationCenter.default.post(name: NotificationName.documentCountDidChangedNotification, object: nil)
            print("\(data)")
        }, failure: { error in
            print("\(error)")
        })
    }

    func getDocument() -> [FileData] {
        return files
    }

    func canSave(_ fileName: String) -> Bool {
        return files.filter({ $0.name == fileName }).isEmpty
    }

    func saveDocument(_ fileName: String) {
        let data = AddFile(name: fileName)
        let service = Service.file(method: .post, data: data)
        Provider.request(service, completion: { (data: FileData) in
            self.files.append(data)

            NotificationCenter.default.post(name: NotificationName.documentCountDidChangedNotification, object: nil)
        }) { error in
            print(error)
        }

    }

    @available(iOS 11.0, *)
    func readPDF(_ fileName: String) -> String {
        guard let pdf = PDFDocument(url: makeURL(fileName)), let text = pdf.string else {
            return ""
        }

        return text
    }
}
