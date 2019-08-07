//
//  Service.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 13/07/2019.
//  Copyright © 2019 Mash-Up. All rights reserved.
//

import Foundation
import Moya

enum State {
    case loading
    case ready
    case error
}

enum Service {
    enum Method {
        case get
        case post
        case put
        case delete
    }

    case addDevice(data: Encodable)
    case file(method: Method, data: Encodable?)
    case hightlight(method: Method, data: Encodable?, fileID: String)
    case deleteHightlight(fileID: String, hightlightID: String)
    case quiz(method: Method, data: Encodable?, fileID: String)
    case quizReStart(fileID: String)

    var deviceID: String {
        return DeviceManager.share.id ?? ""
    }
}

extension Service: TargetType {
    var baseURL: URL {
        let urlString = "http://15.164.62.183:8080/v1/devices"
        guard let url = URL(string: urlString) else {
            assertionFailure("\(urlString) doesn't exist!")
            return URL(string: "")!
        }
        return url
    }

    var path: String {
        switch self {
        case .addDevice:
            return ""
        case .file:
            return "/\(deviceID)/files"
        case .hightlight(_, _, let fileID):
            return "/\(deviceID)/files/\(fileID)/hightlights"
        case .deleteHightlight(let fileID, let hightlightID):
            return "/\(deviceID)/files/\(fileID)/hightlights/\(hightlightID)"
        case .quiz(_, _, let fileID):
            return "/\(deviceID)/files/\(fileID)/quiz"
        case .quizReStart(let fileID):
            return "/\(deviceID)/files/\(fileID)/quiz/re"
        }
    }

    var method: Moya.Method {
        switch self {
        case .addDevice:
            return .post

        case .file(let method, _), .hightlight(let method, _, _), .quiz(let method, _, _):

            // TODO: return method로 하는 방법 체크
            /* Alamofire..
            if let method = method as? HTTPMethod {
                return method
            }
            */

            switch method {
            case .post:
                return .post
            default:
                return .get
            }

        case .deleteHightlight:
            return .delete

        case .quizReStart:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    // TODO: 해당 부분 작업 할 때, API Document 보고 업데이트 시킬 것.
    var task: Task {
        switch self {
        case .addDevice(let data):
            return .requestJSONEncodable(data)

        case .file(let method, let data), .hightlight(let method, let data, _), .quiz(let method, let data, _):

            switch method {
            case .post:
                if let data = data {
                    return .requestJSONEncodable(data)
                }
                return .requestPlain
            default:
                return .requestPlain
            }

        case .deleteHightlight:
            return .requestPlain

        case .quizReStart:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["accept": "application/json", "Content-Type": "application/json"]
    }
}
