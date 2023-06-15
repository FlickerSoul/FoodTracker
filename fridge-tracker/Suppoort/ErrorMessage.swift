//
//  ErrorMessage.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/15/23.
//

import Foundation

struct ErrorMessageDetail {
    var isShowing: Bool = false
    var title: String = ""
    var message: String = ""
    var buttonText: String = "Ok"

    init(isShowing: Bool, title: String, message: String, buttonText: String) {
        self.isShowing = isShowing
        self.title = title
        self.message = message
        self.buttonText = buttonText
    }

    init() {}

    mutating func showErrorMessage(title: String? = nil, message: String? = nil, buttonText: String? = nil) {
        if let title = title {
            self.title = title
        }

        if let message = message {
            self.message = message
        }

        if let buttonText = buttonText {
            self.buttonText = buttonText
        }

        self.isShowing = true
    }
}
