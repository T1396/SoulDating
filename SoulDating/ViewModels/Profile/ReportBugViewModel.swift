//
//  ReportBugViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 14.07.24.
//

import Foundation


class ReportBugViewModel: BaseAlertViewModel {
    enum State { case initial, loading, success }
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    @Published private (set) var state: State = .initial
    @Published var bugDescription = ""
    @Published var additionalDescription = ""
    @Published var bugType: BugType?

    @Published var successfullyReported = false

    // MARK: computed properties
    var bugReport: BugReport {
        BugReport(userId: firebaseManager.userId, bugType: bugType ?? .other, bugDescription: bugDescription, additionalDescription: additionalDescription)
    }

    var bugReportDisabled: Bool {
        bugDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || bugType == nil
    }

    // MARK: functions
    func selectBugType(_ bugType: BugType) {
        self.bugType = bugType
    }


    @MainActor
    func sendBugReport() {
        state = .loading
        do {
            try firebaseManager.database.collection("bugReports").document()
                .setData(from: bugReport) { error in
                    if let error {
                        print("error sending bug report", error.localizedDescription)
                        self.createAlert(title: Strings.error, message: Strings.bugReportFailed)
                        return
                    }

                    self.bugDescription = ""
                    self.additionalDescription = ""
                    self.bugType = nil
                    self.executeDelayed(completion: {
                        self.state = .success
                    }, delay: 1.5)
                    print("successfully send bug report")
                }
        } catch {
            print("error encoding bug report", error.localizedDescription)
        }
    }

}
