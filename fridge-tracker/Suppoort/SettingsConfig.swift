//
//  SettingsConfg.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/12/23.
//

import Foundation

struct SettingsConfig: Codable, Equatable {
    static let SETTINGS_CONFIG_STORAGE_KEY = "observer.universe.food-tracker:settings"
    var notificationTime: Date

    static func getStored() -> Self? {
        if let stored = UserDefaults.standard.data(forKey: Self.SETTINGS_CONFIG_STORAGE_KEY) {
            let converted = try! JSONDecoder().decode(SettingsConfig.self, from: stored)
            return converted
        }

        return nil
    }

    init() {
        let stored = Self.getStored()

        if let stored = stored {
            notificationTime = stored.notificationTime
        } else {
            notificationTime = Date.now
        }
    }

    init(notificationTime: Date) {
        self.notificationTime = notificationTime
    }

    func store() {
        let encoded = try! JSONEncoder().encode(self)
        UserDefaults.standard.set(encoded, forKey: Self.SETTINGS_CONFIG_STORAGE_KEY)
    }
}
