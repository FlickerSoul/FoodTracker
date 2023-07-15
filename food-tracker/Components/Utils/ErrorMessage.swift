//
//  ErrorMessage.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/15/23.
//

import SwiftUI

struct ErrorMessageDetail {
    var isShowing: Bool = false
    var title: String = ""
    var message: String?
    var dismissButtonText: String = "Ok"

    init(isShowing: Bool, title: String, message: String, dismissButtonText: String) {
        self.isShowing = isShowing
        self.title = title
        self.message = message
        self.dismissButtonText = dismissButtonText
    }

    init() {}

    mutating func showErrorMessage(title: String, message: String? = nil, buttonText: String? = nil) {
        self.title = title

        self.message = message

        if let buttonText = buttonText {
            self.dismissButtonText = buttonText
        }

        self.isShowing = true
    }

    var alertView: Alert {
        return Alert(title: Text(self.title), message: self.message == nil ? nil : Text(self.message!), dismissButton: .default(Text(self.dismissButtonText)))
    }
}
