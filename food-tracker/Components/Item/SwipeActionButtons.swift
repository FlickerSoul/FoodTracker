//
//  SwipeActionButton.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/7/23.
//

import SwiftUI

struct SwipeActionButton: View {
    let iconLabel: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: iconLabel)
        }.tint(tint)
    }
}

// TODO: use macros?

struct SwipeArchiveButton: View {
    let action: () -> Void

    var body: some View {
        SwipeActionButton(iconLabel: "archivebox", tint: .yellow, action: action)
    }
}

struct SwipeUnarchiveButton: View {
    let action: () -> Void

    var body: some View {
        SwipeActionButton(iconLabel: "arrow.uturn.left", tint: .green, action: action)
    }
}

struct SwipeDeleteButton: View {
    let action: () -> Void

    var body: some View {
        SwipeActionButton(iconLabel: "trash", tint: .red, action: action)
    }
}

struct SwipeMarkTemplateButton: View {
    let action: () -> Void

    var body: some View {
        SwipeActionButton(iconLabel: "books.vertical", tint: .orange, action: action)
    }
}
