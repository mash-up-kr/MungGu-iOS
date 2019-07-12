//
//  NetworkManager.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 13/07/2019.
//  Copyright © 2019 Mash-Up. All rights reserved.
//

import Foundation
import Moya

class NetworkManager {
    static let share = NetworkManager()

    let provider = MoyaProvider<Service>()

    // MARK: - API Methods

    func request(_ service: Service, completion: @escaping (Response) -> Void) {
        provider.request(service) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.filterSuccessfulStatusCodes()
                    completion(data)
                } catch {
                    assertionFailure("Request Data Error response: [\(response)]")
                }
            case .failure(let error):
                assertionFailure("Request Failure error: [\(error)]")
            }
        }
    }
}
