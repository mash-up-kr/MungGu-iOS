//
//  Document.swift
//  Document Based App template
//
//  Created by Daeyun Ethan on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

typealias DocumentType = Document.TypeName

class Document: UIDocument {

    enum TypeName: String {
        case pdf
        case txt
    }

    override func contents(forType typeName: String) throws -> Any {
        return Data()
    }

    override func load(fromContents contents: Any, ofType typeName: String?) throws {

        guard let typeName = typeName, let type = TypeName(typeName: typeName) else { return }

        if let data = contents as? Data {
            let name = DocumentDataManager.share.fileName
            let url = DocumentDataManager.share.makeURL(name, type: type.rawValue)
            do {
                try data.write(to: url)

                DocumentDataManager.share.saveDocument(name)
                DocumentDataManager.share.fileName = ""
            } catch {
                assertionFailure("Couldn't Save!!")
            }
        }
    }
}

extension DocumentType {
    init?(typeName: String) {
        if typeName.contains("pdf") {
            self = .pdf
        } else if typeName.contains("text") || typeName.contains("txt") {
            self = .txt
        } else {
            return nil
        }
    }
}
