//
//  CloudKitSyncIndicator.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 6/26/23.
//

import CloudKit
import SwiftUI

enum CloudKitError {
    case couldNotDetermine
    case restricted
    case noAccount
    case temporarilyUnavailable
    case unknown
}

struct CloudKitSyncIndicator: View {
    @State var icloudSignedIn: Bool = false
    @State var error: CloudKitError? = nil

    var body: some View {
        Image(systemName: icloudSignedIn ? "icloud" : "exclamationmark.icloud")
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
