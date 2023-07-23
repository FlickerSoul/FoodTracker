//
//  URLUtils.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 7/23/23.
//

import Foundation

internal let FOOD_TRACKER_URL_SCHEME = "uofoodtracker"

enum URLAction: String {
    case viewItem = "view-item"
}

func getURLComponents(for url: URL, of scheme: String) -> URLComponents? {
    guard url.scheme == scheme else {
        return nil
    }

    return URLComponents(url: url, resolvingAgainstBaseURL: true)
}

func getURLAction(for components: URLComponents) -> URLAction? {
    guard let host = components.host else { return nil }
    return URLAction(rawValue: host)
}
