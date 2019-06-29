//
//  PDFContent.swift
//  MungGu iOS
//
//  Created by juhee on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import PDFKit

struct PDFContent {
    var fileName: String

    @available(iOS 11.0, *)
    func readPDF() -> String {
        guard let urlPath = Bundle.main.url(forResource: self.fileName, withExtension: "pdf") else {
            preconditionFailure("no file")
        }
        guard let pdf = PDFDocument(url: urlPath) else {
            return ""
        }

        return pdf.string!
    }
}
