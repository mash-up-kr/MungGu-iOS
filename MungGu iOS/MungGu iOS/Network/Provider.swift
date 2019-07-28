//
//  Provider.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 13/07/2019.
//  Copyright © 2019 Mash-Up. All rights reserved.
//

import Foundation
import Moya
import Result

typealias ResultCompletion<T: Decodable> = (T) -> Void

struct Provider {
    private static let provider = MoyaProvider<Service>()

    // MARK: - API Methods

    static func request<T: Decodable>(_ service: Service, completion: @escaping ResultCompletion<T>, failure: @escaping ((Error) -> Void) = { _ in }) {
        provider.request(service) { result in
            self.task(result, completion: completion, failure: failure)
        }
    }
}

extension Provider {
    static func task<T: Decodable>(_ result: Result<Moya.Response, MoyaError>, completion: @escaping ((T) -> Void), failure: @escaping ((Error) -> Void)) {
        switch result {
        case .success(let response):
            let statusCode = response.statusCode

            switch statusCode {
            case 200..<300:
                guard let data = try? response.map(T.self) else {
                    preconditionFailure("Fail: \(response) does not found !!")
                }
                completion(data)

            case 400..<500:
                guard let data = try? response.map(ErrorData.self) else {
                    preconditionFailure("Fail: \(response) does not found !!")
                }
                failure(NSError(domain: data.msg ?? "Unknown", code: data.code ?? -9999, userInfo: nil))

            default:
                failure(NSError(domain: "Unknown", code: -9999, userInfo: nil))
            }

        case let .failure(error):
            failure(error)
        }
    }
}
