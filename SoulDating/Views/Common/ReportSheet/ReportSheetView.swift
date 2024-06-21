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
    let reportedUser: User
    var onBlocked: () -> Void

    
    // MARK: init
    init(showSheet: Binding<Bool>, userId: String, reportedUser: User, onBlocked: @escaping () -> Void) {
        self._showSheet = showSheet
        self._reportViewModel = StateObject(wrappedValue: ReportViewModel(userId: userId, reportedUser: reportedUser))
        self.reportedUser = reportedUser
        self.onBlocked = onBlocked
    }
    
    // MARK: body
    var body: some View {
        VStack {
            switch reportViewModel.reportStatus {
            case .initial:
                /// all actions to choose
                ForEach(ReportOption.allCases) { option in
                    OptionRow(systemName: option.icon, text: option.title(for: reportedUser.name ?? "")) {
                        reportViewModel.processOption(option)
                    }
                }
            case .input:
                reportView
            case .loading:
                loadingButton
            case .success:
                successButton
                    .onAppear {
                        executeDelayed {
                            showSheet.toggle()
                            onBlocked()
                        }
                    }
            case .failure:
                failureIcon
            }
            
            
        }
        .alert(reportViewModel.alertTitle, isPresented: $reportViewModel.showAlert, actions: {
            Button("Cancel", role: .cancel, action: reportViewModel.dismissAlert)
            Button("Block", role: .destructive, action: reportViewModel.blockUser)
        }, message: {
            Text(reportViewModel.alertMessage)
        })
        .animation(.easeInOut, value: reportViewModel.status)
        .padding()
        .presentationDetents([.fraction(presentationHeight)])
        .presentationDragIndicator(.visible)
        .onChange(of: reportViewModel.reportStatus) { oldValue, newValue in
            if newValue == .input {
                withAnimation(.linear(duration: 0.3)) {
                    presentationHeight = 1.0
                }
            }
        }
    }

    var loadingButton: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .frame(width: 50, height: 50)
            
            Text(reportViewModel.loadingMessage)
                .appFont(size: 18, textWeight: .bold)
                .multilineTextAlignment(.center)
        }
    }
    
    var successButton: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.green)
                .transition(.scale)
            
            Text(reportViewModel.resultMessage)
                .appFont(size: 18, textWeight: .bold)
                .multilineTextAlignment(.center)
        }
    }
    
    var processButton: some View {
        Button {
            reportViewModel.reportStatus = .initial
        } label: {
            Text("Ok")
                .appFont()
        }
    }
    
    var failureIcon: some View {
        VStack {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
                .transition(.scale)
            
            Text(reportViewModel.resultMessage)
                .appFont(size: 18, textWeight: .bold)
                .multilineTextAlignment(.center)
            
            processButton
        }
    }
    
    var reportView: some View {
        VStack(alignment: .leading) {
            BackArrow(action: goToOptions)

            Text("Tell us the reason why you want to report \(reportedUser.name ?? "")")
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
            Text("We need more information what exactly happened")
                .appFont(size: 14, textWeight: .extralight)
            AppTextField("Enter more detailed information", text: $reportViewModel.reportMessage)
            
            
            Button(action: { reportViewModel.reportUser() }){
                Text("Send Report")
                    .appButtonStyle(color: .red,fullWidth: true)
            }
            .buttonStyle(PressedButtonStyle())
            .disabled(!reportViewModel.isReportEnabled)
        }
    }
    
    func goToOptions() {
        withAnimation {
            reportViewModel.reportStatus = .initial
            presentationHeight = 0.25
        }
    }
}

#Preview {
    ReportSheetView(showSheet: .constant(true), userId: "dksla", reportedUser: User(id: "dskla", name: "Karate Andi" , registrationDate: .now), onBlocked: {})
}
