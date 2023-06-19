//
//  SettingsConfg.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/12/23.
//

import Foundation

// let FULL_NAME: StaticString = "observer.universe.food-tracker"  // no constexpr :(((

enum SettingsKeys: String, CaseIterable {
    case openAIKey = "observer.universe.food-tracker.open-ai-key"
    case generalSettingsKey = "observer.universe.food-tracker.general-settings"
}

struct SettingsConfig: Codable, Equatable {
    static let SETTINGS_CONFIG_STORAGE_KEY = SettingsKeys.generalSettingsKey

    var notificationTime: Date

    static func getStored() -> Self? {
        if let stored = UserDefaults.standard.data(forKey: Self.SETTINGS_CONFIG_STORAGE_KEY.rawValue) {
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
        UserDefaults.standard.set(encoded, forKey: Self.SETTINGS_CONFIG_STORAGE_KEY.rawValue)
    }
}
