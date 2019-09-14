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
    private static let provider = MoyaProvider<Service>(plugins: [NetworkLoggerPlugin(verbose: true)])

    private static let networkError = [
        NSURLErrorCannotFindHost,
        NSURLErrorCannotConnectToHost,
        NSURLErrorNetworkConnectionLost,
        NSURLErrorDNSLookupFailed,
        NSURLErrorHTTPTooManyRedirects,
        NSURLErrorResourceUnavailable,
        NSURLErrorNotConnectedToInternet,
        NSURLErrorRedirectToNonExistentLocation,
        NSURLErrorInternationalRoamingOff,
        NSURLErrorCallIsActive,
        NSURLErrorDataNotAllowed,
        NSURLErrorSecureConnectionFailed,
        NSURLErrorCannotLoadFromNetwork
    ]

    // MARK: - API Methods

    static func request<T: Decodable>(_ service: Service, completion: @escaping ResultCompletion<T>, failure: @escaping ((Error, _ networkError: Bool) -> Void) = { _, _  in }) {
        provider.request(service) { result in
            self.task(result, completion: completion, failure: failure)
        }
    }
}

private extension Provider {
    static func task<T: Decodable>(_ result: Result<Moya.Response, MoyaError>, completion: @escaping ((T) -> Void), failure: @escaping ((Error, _ networkError: Bool) -> Void)) {
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
                failure(NSError(domain: data.msg ?? "Unknown", code: data.code ?? -9999, userInfo: nil), false)

            default:
                failure(NSError(domain: "Unknown", code: -9999, userInfo: nil), false)
            }

        case let .failure(error):
            switch error {
            case .underlying(let underlyingError, _):
                if networkError.contains((underlyingError as NSError).code) {
                    failure(error, true)
                    return
                }
            default:
                break
            }
            failure(error, false)
        }
    }
}
