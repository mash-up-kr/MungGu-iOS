//
//  DeviceManager.swift
//  MungGu iOS
//
//  Created by Daeyun Ethan on 24/07/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation

typealias DeviceIdentifier = DeviceManager.Identifier

class DeviceManager: NetworkErrorPopUpShowable {
    static let share = DeviceManager()

    static var appVersionString: String? {
        guard let infoDict = Bundle.main.infoDictionary else {
            return nil
        }

        return infoDict["CFBundleShortVersionString"] as? String
    }

    static func getAppStoreVersion() -> String? {
        guard let info = Bundle.main.infoDictionary, let bundleID = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(bundleID)") else {
                return nil
        }

        guard let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any],
            let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                return nil
        }

        return version
    }

    struct Identifier {
        static let deviceKey = "deviceKey"
        static let deviceID = "deviceID"
    }

    private(set) var id: String?

    private init() { }

    func configure() {
        if let id = getDeviceID() {
            self.id = id
        } else {
            requestDeviceID()
        }
    }

    private func makeDeviceKey() -> String {
        if let deviceKey = UserDefaults.standard.string(forKey: Identifier.deviceKey) {
            return deviceKey
        } else {
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: Identifier.deviceKey)

            return uuid
        }
    }

    private func saveDeviceID(_ id: String) {
        UserDefaults.standard.set(id, forKey: Identifier.deviceID)
        self.id = id
    }

    private func getDeviceID() -> String? {
        if let deviceKey = UserDefaults.standard.string(forKey: Identifier.deviceID) {
            return deviceKey
        }
        return nil
    }

    private func requestDeviceID() {
        let deviceKey = makeDeviceKey()
        let service = Service.addDevice(data: AddDevice(deviceKey: deviceKey))

        Provider.request(service, completion: { (data: DeviceInfo) in
            guard let id = data.id else {
                assertionFailure("Fail requestDeviceID!!")
                return
            }

            self.saveDeviceID(String(id))
        }, failure: { error, networkError in
            if networkError {
                self.showNetworkErrorAlert(okayAction: { _ in
                    self.requestDeviceID()
                })
            } else {
                print(error)
            }
        })
    }
}
