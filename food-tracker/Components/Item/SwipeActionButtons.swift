//
//  SwipeActionButton.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/7/23.
//

import SwiftUI

struct SwipeActionButton: View {
    let text: String?
    let iconLabel: String
    let tint: Color
    let action: () -> Void
    let role: ButtonRole?

    init(text: String? = nil, iconLabel: String, role: ButtonRole? = nil, tint: Color, action: @escaping () -> Void) {
        self.text = text
        self.iconLabel = iconLabel
        self.tint = tint
        self.action = action
        self.role = role
    }

    var body: some View {
        Button(role: self.role) {
            action()
        } label: {
            if let text = text {
                Label(text, systemImage: iconLabel)
            } else {
                Image(systemName: iconLabel)
            }
        }
        .tint(tint)
    }
}

// TODO: use macros?

struct SwipeArchiveButton: View {
    let action: () -> Void

    var body: some View {
        SwipeActionButton(text: "Archive", iconLabel: "archivebox", tint: .yellow, action: action)
    }
}

struct SwipeUnarchiveButton: View {
    let action: () -> Void

    var body: some View {
        SwipeActionButton(text: "Unarchive", iconLabel: "arrow.uturn.left", tint: .green, action: action)
    }
}

struct SwipeDeleteButton: View {
    let action: () -> Void

    var body: some View {
        SwipeActionButton(text: "Delete", iconLabel: "trash", role: .destructive, tint: .red, action: action)
    }
}

struct SwipeMarkTemplateButton: View {
    let action: () -> Void

    var body: some View {
        SwipeActionButton(text: "Mark As Template", iconLabel: "books.vertical", tint: .orange, action: action)
    }
}

struct SwipeConsumeButton: View {
    let action: () -> Void

    var body: some View {
        SwipeActionButton(text: "Consume", iconLabel: "checklist", tint: .mint, action: action)
    }
}

struct SwipePutBackButton: View {
    let action: () -> Void

    var body: some View {
        SwipeActionButton(text: "Put Back", iconLabel: "checklist.unchecked", tint: .orange, action: action)
    }
}
