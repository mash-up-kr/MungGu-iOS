//
//  HighlightManager.swift
//  MungGu iOS
//
//  Created by juhee on 08/08/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation

class HighlightManager: HighlightManagerType {
    static let DidChangedSelectedFile: Notification.Name = Notification.Name("didChangedSelectedFile")
    static let DidChangedHighlights: Notification.Name = Notification.Name("didChangedHighlights")
    static let share = HighlightManager()

    private(set) var fileData: FileData? {
        didSet {
            NotificationCenter.default.post(name: HighlightManager.DidChangedSelectedFile, object: fileData)
        }
    }
    private(set) var highlights: [Highlight] = [] {
        didSet {
            NotificationCenter.default.post(name: HighlightManager.DidChangedHighlights, object: highlights)
        }
    }

    private init() { }

    func loadFile(fileData: FileData) {
        self.fileData = fileData
        guard let fileID = fileData.id else { return }
        Provider.request(.highlight(method: .get, data: nil, fileID: "\(fileID)"), completion: {[weak self] highlights in
            self?.highlights = highlights
//            completion.(highlights)
        }, failure: { error in
            print("\(error)")
        })
    }
}

protocol HighlightManagerType {
    func loadFile(fileData: FileData)
}
