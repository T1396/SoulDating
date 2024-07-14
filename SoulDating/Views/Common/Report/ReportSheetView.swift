//
//  OptionsSheet.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.06.24.
//

import SwiftUI

struct ReportSheetView: View {
    // MARK: properties
    @StateObject private var reportViewModel: ReportViewModel
    @State private var presentationHeight = 0.25
    @Binding var showSheet: Bool
    var onBlocked: () -> Void

    
    // MARK: init
    init(showSheet: Binding<Bool>, reportedUser: FireUser, onBlocked: @escaping () -> Void) {
        self._showSheet = showSheet
        self._reportViewModel = StateObject(wrappedValue: ReportViewModel(reportedUser: reportedUser))
        self.onBlocked = onBlocked
    }
    
    // MARK: body
    var body: some View {
        VStack {
            switch reportViewModel.reportStatus {
            case .initial:
                /// all actions to choose
                ForEach(ReportOption.allCases) { option in
                    OptionRow(
                        systemName: option.icon,
                        text: option.title(for: reportViewModel.reportedUser.name ?? "")) {
                        withAnimation {
                            reportViewModel.processOption(option)
                        }
                    }
                }
            case .input:
                reportView
            case .loading:
                LoadingView(message: reportViewModel.loadingMessage)
            case .success:
                SuccessView(message: reportViewModel.resultMessage)
                    .onAppear {
                        executeDelayed(completion: {
                            // call closure
                            onBlocked()
                        }, delay: 1.25)
                    }
            case .failure:
                FailureView(message: reportViewModel.resultMessage)
                Button(action: resetToInitial) {
                    Text("OK")
                        .appButtonStyle(fullWidth: true)
                }
            }
        }
        .animation(.easeInOut, value: reportViewModel.reportStatus)

        
        .alert(reportViewModel.alertTitle, isPresented: $reportViewModel.showAlert, actions: {
            Button(Strings.cancel, role: .cancel, action: reportViewModel.dismissAlert)
            Button(Strings.block, role: .destructive, action: reportViewModel.blockUser)
        }, message: {
            Text(reportViewModel.alertMessage)
        })
        .padding()
        .presentationDetents([.fraction(presentationHeight)])
        .presentationDragIndicator(.visible)
        .onChange(of: reportViewModel.reportStatus) { _, newValue in
            if newValue == .input {
                withAnimation {
                    presentationHeight = 1.0
                }
            } else {
                withAnimation {
                    presentationHeight = 0.25
                }
            }
        }
    }
    
    // MARK: REPORT OPTIONS VIEW
    var reportView: some View {
        VStack(alignment: .leading) {
            BackArrow(action: resetToInitial)
            Text(String(format: Strings.reasonForReport, reportViewModel.reportedUser.name ?? ""))
                .appFont(size: 24, textWeight: .bold)
                .padding(.top, 8)
                
            ScrollView {
                ForEach(ReportReason.allCases) { reason in
                    OptionToggleRow(systemName: reason.icon, text: reason.title, isSelected: reportViewModel.reportReasons.contains(where: { $0 == reason })) {
                        reportViewModel.toggleReason(reason)
                    }
                }
            }
            .scrollIndicators(.never)
            Text(Strings.needMoreInfo)
                .appFont(size: 14, textWeight: .extralight)
            AppTextField(Strings.enterMoreInfo, text: $reportViewModel.reportMessage)

            Button(action: reportUser) {
                Text(Strings.sendReport)
                    .appButtonStyle(color: .red, fullWidth: true)
            }
            .buttonStyle(PressedButtonStyle())
            .disabled(!reportViewModel.isReportEnabled)


        }
    }

    // MARK: functions
    private func resetToInitial() {
        withAnimation {
            reportViewModel.reportStatus = .initial
        }
    }

    private func reportUser() {
        withAnimation {
            reportViewModel.reportUser()
        }
    }
}

#Preview {
    ReportSheetView(showSheet: .constant(true), reportedUser: FireUser(id: "dskla", name: "Karate Andi", registrationDate: .now), onBlocked: {})
}
