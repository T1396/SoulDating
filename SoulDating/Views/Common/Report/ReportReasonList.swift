//
//  ReportReasonList.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 16.07.24.
//

import SwiftUI

struct ReportReasonList: View {
    @ObservedObject var reportViewModel: ReportViewModel
    var body: some View {
        // MARK: REPORT OPTIONS VIEW
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
    ReportReasonList(reportViewModel: ReportViewModel(reportedUser: FireUser(id: "1")))
}
