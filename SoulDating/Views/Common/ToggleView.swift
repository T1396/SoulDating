//
//  ToggleView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 12.06.24.
//

import SwiftUI

struct ToggleView: View {
    var isSelected: Bool
    var body: some View {
        Image(systemName: isSelected ? "circle.fill" : "circle")
            .foregroundColor(isSelected ? .green : .gray)
    }
}
