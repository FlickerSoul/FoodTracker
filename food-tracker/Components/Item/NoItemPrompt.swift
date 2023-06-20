//
//  NoItemPrompt.swift
//  fridge-tracker
//
//  Created by Heyuan Zeng on 6/8/23.
//

import SwiftUI

struct NoItemPrompt: View {
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "checkmark.seal")
            Text("No items!")
            Spacer()
        }
    }
}

#Preview {
    NoItemPrompt()
}
