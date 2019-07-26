//
//  Document.swift
//  Document Based App template
//
//  Created by Daeyun Ethan on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class Document: UIDocument {
    override func contents(forType typeName: String) throws -> Any {
        return Data()
    }

    override func load(fromContents contents: Any, ofType typeName: String?) throws {

        if typeName == "com.adobe.pdf", let data = contents as? Data {

            let name = DocumentDataManager.share.fileName
            let url = DocumentDataManager.share.makeURL(name)
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
