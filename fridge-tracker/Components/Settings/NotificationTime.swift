//
//  NotificationTime.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/12/23.
//

import SwiftUI

struct NotificationTime: View {
    @Binding var time: Date

    var body: some View {
        DatePicker("Notification Time", selection: $time, displayedComponents: .hourAndMinute)
    }
}
