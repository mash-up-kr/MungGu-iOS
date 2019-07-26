//
//  DeviceManager.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 24/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation

class DeviceManager {
    static let share = DeviceManager()

    private let deviceKeyID = "deviceKey"

    private init() { }

    private func makeDeviceKey() -> String {
        if let deviceKey = UserDefaults.standard.string(forKey: deviceKeyID) {
            return deviceKey
        } else {
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: deviceKeyID)

            return uuid
        }
    }

    func requestDeviceID() {
        let deviceKey = makeDeviceKey()
        let service = Service.addDevice(data: AddDevice(deviceKey: deviceKey))

        NetworkManager.share.request(service) { response in
            guard let data = try? response.map(DeviceInfo.self) else {
                assertionFailure("Fail requestDeviceID!!")
                return
            }

            print("deviceID \(data)")
        }
    }
}
