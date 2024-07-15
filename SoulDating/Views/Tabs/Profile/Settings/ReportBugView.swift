//
//  ReportBugView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.07.24.
//

import SwiftUI

struct ReportBugView: View {
    // MARK: properties
    @StateObject private var reportBugVm = ReportBugViewModel()
    @Environment(\.dismiss) var dismiss

    // MARK: body
    var body: some View {
        VStack(spacing: 0) {
            switch reportBugVm.state {
            case .initial:
                bugReportInputView
            case .loading:
                Spacer()
                LoadingView(message: Strings.reportBeeingSend)
                    .padding()
                Spacer()
            case .success:
                Spacer()
                SuccessView(message: Strings.successfullyReportedBug)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            dismiss()
                        }
                    }
                    .padding()
                Spacer()
            }

            HStack {
                Button(action: cancel) {
                    Text(Strings.cancel)
                }
                Spacer()
                Button(action: reportBugVm.sendBugReport) {
                    Text(Strings.send)
                        .appButtonStyle()
                }
                .disabled(reportBugVm.bugReportDisabled)
            }
            .padding([.horizontal, .top])
            .background(.thinMaterial)

        }
        .animation(.default, value: reportBugVm.state)
        .alert(reportBugVm.alertTitle, isPresented: $reportBugVm.showAlert) {
            Button("OK", action: reportBugVm.dismissAlert)
        } message: {
            Text(reportBugVm.alertMessage)
        }

    }

    private var bugReportInputView: some View {
        ScrollView {
            VStack {
                headerText(Strings.bugTypeHeader)
                ForEach(BugType.allCases) { bugType in
                    OptionToggleRow(systemName: bugType.icon, text: bugType.title, isSelected: reportBugVm.bugType == bugType) {
                        withAnimation {
                            reportBugVm.selectBugType(bugType)
                        }
                    }
                }
                .padding(.horizontal)


                if reportBugVm.bugType != nil {
                    headerText(Strings.bugDescriptionSupport)
                        .padding(.top)

                    TextField(Strings.reportBugPlaceholder, text: $reportBugVm.bugDescription, axis: .vertical)
                        .descriptionTextFieldStyle(lineLimit: 5)

                    headerText(Strings.bugReportAdditionalInfo)
                    TextField(Strings.bugReportAdditionalPlaceholder, text: $reportBugVm.additionalDescription, axis: .vertical)
                        .descriptionTextFieldStyle(lineLimit: 3)

                    Spacer(minLength: 20)
                }
            }
        }
    }

    private func cancel() {
        dismiss()
    }


    private func headerText(_ text: String) -> some View {
        Text(text)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .appFont(size: 16, textWeight: .semibold)
    }
}

#Preview {
    ReportBugView()
}
