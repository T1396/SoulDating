//
//  EditBoolView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 21.06.24.
//

import SwiftUI

struct EditBoolView: View {
    var title: String
    var subtitle: String
    @State private var isEnabled: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)

            Toggle(isOn: $isEnabled) {
                Text("Switch")
            }
            .toggleStyle(SymbolToggleStyle(systemImage: "checkmark.circle.fill", activeColor: .cyan))
        }
        .padding()
    }
}

struct SymbolToggleStyle: ToggleStyle {

    var systemImage: String = "checkmark"
    var activeColor: Color = .green

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            RoundedRectangle(cornerRadius: 30)
                .fill(configuration.isOn ? activeColor : Color(.systemGray5))
                .overlay {
                    Circle()
                        .fill(.white)
                        .padding(3)
                        .overlay {
                            Image(systemName: systemImage)
                                .foregroundColor(configuration.isOn ? activeColor : Color(.systemGray5))
                        }
                        .offset(x: configuration.isOn ? 10 : -10)

                }
                .frame(width: 50, height: 32)
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}

#Preview {
    EditBoolView(title: "Do you date smokers?", subtitle: "")
}
