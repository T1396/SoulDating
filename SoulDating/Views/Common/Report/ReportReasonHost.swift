//
//  ReportReasonHost.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 16.07.24.
//

import SwiftUI

struct ReportReasonHost: View {
    @ObservedObject var reportVm: ReportViewModel
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {

            switch reportVm.reportStatus {
            case .initial:
                EmptyView() // not needed here
            case .input:
                ReportReasonList(reportViewModel: reportVm)
            case .loading:
                LoadingView(message: reportVm.loadingMessage)
            case .success:
                SuccessView(message: reportVm.resultMessage)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            dismissView()
                        }
                    }
            case .failure:
                FailureView(message: reportVm.resultMessage)
                Button(action: resetToInput) {
                    Text("OK")
                        .appButtonStyle(fullWidth: true)
                }
            }
        }
        .onAppear {
            reportVm.processOption(.blockReport)
        }
        .animation(.easeInOut, value: reportVm.reportStatus)
    }


    private func dismissView() {
        withAnimation {
            dismiss()
        }
    }

    private func resetToInput() {
        withAnimation {
            reportVm.reportStatus = .input
        }
    }


}

#Preview {
    ReportReasonHost(reportVm: ReportViewModel(reportedUser: FireUser(id: "1")))
}
