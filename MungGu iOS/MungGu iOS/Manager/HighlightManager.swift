//
//  HighlightManager.swift
//  MungGu iOS
//
//  Created by juhee on 08/08/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation

class HighlightManager: HighlightManagerType, NetworkErrorPopUpShowable {
    static let DidChangedSelectedFile: Notification.Name = Notification.Name("didChangedSelectedFile")
    static let DidChangedHighlights: Notification.Name = Notification.Name("didChangedHighlights")
    static let share = HighlightManager()

    private(set) var fileData: FileData? {
        didSet {
            NotificationCenter.default.post(name: HighlightManager.DidChangedSelectedFile, object: fileData)
        }
    }
    var highlights: [Highlight] = [] {
        didSet {
            NotificationCenter.default.post(name: HighlightManager.DidChangedHighlights, object: highlights)
        }
    }

    private init() { }

    func loadFile(fileData: FileData) {
        self.fileData = fileData
        guard let fileID = fileData.id else { return }
        self.highlights = []
//        Provider.request(.highlight(method: .get, data: nil, fileID: "\(fileID)"), completion: {[weak self] response in
//            let respon: Highlights = response
//            self?.highlights = response.highlights
////            completion.(highlights)
//        }, failure: { error in
//            print("\(error)")
//        })
    }

    func saveFile(_ highlights: [Highlight]) {
        guard let fileID = fileData?.id else { return }
        Provider.request(.highlight(method: .post, data: highlights, fileID: "\(fileID)"), completion: {[weak self] highlights in
            self?.highlights = highlights
            }, failure: { error, networkError in
                if networkError {
                    self.showNetworkErrorAlert(okayAction: { _ in
                        self.saveFile(highlights)
                    })
                } else {
                    print(error)
                }
        })
    }

    func getHighlights() -> [Highlight] {
        return highlights
    }
}

protocol HighlightManagerType {
    var highlights: [Highlight] { get set }

    func loadFile(fileData: FileData)
    func saveFile(_ highlights: [Highlight])
    func getHighlights() -> [Highlight]
}
