//
//  CloudKitSyncIndicator.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 6/26/23.
//

import CloudKit
import SwiftUI

enum CloudKitError: String {
    case couldNotDetermine = "Cannot Determine "
    case restricted = "Restricted"
    case noAccount = "No Account"
    case temporarilyUnavailable = "Temporarily Unavailable"
    case unknown = "Uknown"
}

struct CloudKitSyncIndicator: View {
    @State private var icloudSignedIn: Bool = false
    @State private var error: CloudKitError? = nil

    private var statusText: String {
        return icloudSignedIn ? "Signed In" : (error?.rawValue ?? "Internal Error")
    }

    var body: some View {
        HStack {
            Text(statusText)

            Image(systemName: icloudSignedIn ? "icloud" : "exclamationmark.icloud")
        }
        .onAppear(perform: checkStatus)
    }

    func checkStatus() {
        CKContainer.default().accountStatus { status, _ in
            DispatchQueue.main.async {
                switch status {
                case .available:
                    self.icloudSignedIn = true
                case .couldNotDetermine:
                    self.error = .couldNotDetermine
                case .restricted:
                    self.error = .restricted
                case .noAccount:
                    self.error = .noAccount
                case .temporarilyUnavailable:
                    self.error = .temporarilyUnavailable
                default:
                    self.error = .unknown
                }
            }
        }
    }
}

#Preview {
    CloudKitSyncIndicator()
}
