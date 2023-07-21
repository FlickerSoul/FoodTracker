//
//  ItemConsumption.swift
//  food-tracker
//
//  Created by Heyuan Zeng on 7/21/23.
//

import SwiftUI

struct ItemConsumption: View {
    let consumption: String
    
    init(_ consumption: String) {
        self.consumption = consumption
    }
    
    init(used: UInt, total: UInt) {
        self.init("\(used) / \(total)")
    }
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "list.bullet.clipboard")
            Text(consumption)
        }
    }
}

#Preview {
    ItemConsumption("1 / 10")
}
