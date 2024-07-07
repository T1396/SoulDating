//
//  ToggleStyle.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 07.07.24.
//

import SwiftUI

struct SymbolToggleStyle: ToggleStyle {

    var systemImage: String = "checkmark.circle.fill"
    var activeColor: Color = .accent
    var systemImageDisables: String = "xmark.circle.fill"


    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            RoundedRectangle(cornerRadius: 30)
                .fill(configuration.isOn ? activeColor : .red)
                .overlay {
                    Circle()
                        .fill(.white)
                        .padding(3)
                        .overlay {
                            Image(systemName: configuration.isOn ? systemImage : systemImageDisables)
                                .foregroundColor(configuration.isOn ? activeColor : .red)
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
    @State var isOnDa = false
    return VStack {
        Toggle("Hallo", isOn: $isOnDa)
            .toggleStyle(SymbolToggleStyle())
    }
}
