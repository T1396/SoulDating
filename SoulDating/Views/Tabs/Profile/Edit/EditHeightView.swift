//
//  EditNumberView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 23.06.24.
//

import SwiftUI

struct EditHeightView: View {
    // MARK: properties
    let title: String
    let supportText: String?
    let path: String
    @Binding var initialValue: Double?

    @EnvironmentObject var editVm: EditUserViewModel
    @Environment(\.dismiss) var dismiss

    @State private var height: Double

    // MARK: computed properties
    var disabledSaving: Bool {
        initialValue == height
    }

    var heightLocale: Measurement<UnitLength> {
        Measurement(value: height, unit: UnitLength.centimeters)
    }

    private let formatStyle = Measurement<UnitLength>.FormatStyle(
        width: .narrow,
        locale: .autoupdatingCurrent,
        usage: .personHeight,
        numberFormatStyle: .number
    )

    // MARK: init
    init(title: String, path: String, initialValue: Binding<Double?>, supportText: String?) {
        self.title = title
        self.supportText = supportText
        self._height = State(initialValue: initialValue.wrappedValue ?? 180)
        self._initialValue = initialValue
        self.path = path
    }
    
    // MARK: body
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .appFont(size: 32, textWeight: .bold)
            Spacer()
            
            // formatted height
            Text(heightLocale, format: formatStyle)
                .appFont(size: 22, textWeight: .semibold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Slider(
                value: $height,
                in: 120...240,
                step: 1
            ) {
            } minimumValueLabel: {
                Text(measurement(120), format: formatStyle)
                    .appFont()
            } maximumValueLabel: {
                Text(measurement(240), format: formatStyle)
                    .appFont()
            }
            
            Spacer()
            
            HStack {
                Button(Strings.cancel) { dismiss() }
                Spacer()
                Button(action: save) {
                    Text(Strings.update)
                        .appButtonStyle()
                }
                .disabled(disabledSaving)
            }
        }
        .padding()
    }
    
    // MARK: functions
    private func save() {
        editVm.updateUserField(path, with: height)
        initialValue = height
        dismiss()
    }

    private func measurement(_ value: Double) -> Measurement<UnitLength> {
        Measurement(value: value, unit: UnitLength.centimeters)
    }
}

#Preview {
    EditHeightView(title: "Change your height", path: "1", initialValue: .constant(180), supportText: nil)
        .environment(\.locale, Locale(identifier: "ja-JP"))
}
