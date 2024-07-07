//
//  ReportViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 16.06.24.
//

import Foundation
import Firebase
import SwiftUI


class ReportViewModel: BaseAlertViewModel {
    enum Status {
        case initial, input, loading, success, failure
    }
    
    // MARK: properties
    
    private let firebaseManager = FirebaseManager.shared
    private let userService: UserService
    let reportedUser: FireUser

    @Published var reportStatus: Status = .initial
    @Published var reportMessage = ""
    @Published var reportReasons: [ReportReason] = []
    @Published var selectedAction: ReportOption?
    
    // MARK: computed properties
    var isReportEnabled: Bool {
        !reportMessage.isEmpty && !reportReasons.isEmpty
    }
    
    // MARK: init
    init(reportedUser: FireUser, userService: UserService = .shared) {
        self.reportedUser = reportedUser
        self.userService = userService
    }
    
    // MARK: functions
    /// checks/unchecks the inserted reportReason
    func toggleReason(_ reason: ReportReason) {
        if let index = reportReasons.firstIndex(of: reason) {
            reportReasons.remove(at: index)
        } else {
            reportReasons.append(reason)
        }
    }
    
    /// receives a report option and starts the corresponding routine
    func processOption(_ reportOption: ReportOption) {
        switch reportOption {
        case .block:
            // show an alert when user want to block the other user
            createAlert(
                title: reportOption.title(for: reportedUser.name ?? ""),
                message: reportOption.confirmationMessage(for: reportedUser.name ?? ""))
        case .blockReport:
            // when reporting switch to input state to read in reportReasons and text
            reportStatus = .input
        }
    }
    
    
    /// Adds a user to the "blockedUsers" list in firestore and to the user locally in userService
    func blockUser() {
        loadingMessage = "Blocking \(reportedUser.name ?? "")..."
        reportStatus = .loading
        let userRef = firebaseManager.database.collection("users").document(userService.user.id)
        userRef.updateData([
            "blockedUsers": FieldValue.arrayUnion([reportedUser.id])
        ]) { error in
            if let error {
                print("Error blocking user", error.localizedDescription)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.resultMessage = "There was an error while blocking \(self.reportedUser.name ?? ""), please try again or report a bug"
                    self.reportStatus = .failure
                }
            } else {
                print("User successfully blocked.")
                // add blocked user to user in userservice
                self.userService.user.blockedUsers?.append(self.reportedUser.id)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.resultMessage = "Successfully blocked \(self.reportedUser.name ?? "")"
                    self.reportStatus = .success
                }
            }
        }
    }
    
    override func dismissAlert() {
        showAlert = false
        reportStatus = .initial
    }
    
    /// creates a report document and updates the resultMessage, also blocks the user
    func reportUser() {
        loadingMessage = "Reporting \(reportedUser.name ?? "")..."
        reportStatus = .loading
        let reportDocument = createReportDictionary()
        firebaseManager.database.collection("reports").document(userService.user.id)
            .setData(reportDocument) { error in
                if let error {
                    print("there was an error while creating report document and upload to firestore", error.localizedDescription)
                    self.resultMessage = "Oops, an error occured, please try again or make a bug report"
                    self.reportStatus = .failure
                    return
                }
                
                self.executeDelayed(completion: {
                    self.blockUser()
                }, delay: 0.75)
            }
    }
}

// MARK: create report dict
extension ReportViewModel {
    func createReportDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "userId": userService.user.id,
            "reportedUserId": reportedUser.id,
            "reportReason": reportReasons.map { $0.rawValue },
            "reportMessage": reportMessage
        ]
        return dict
    }
}


/// messages for errors
extension ReportViewModel {
    var blockUserErrorMessage: String {
        "There was an error while blocking \(reportedUser.name ?? ""). Please try again or report a bug."
    }
    
    var reportUserErrorMessage: String {
        "Oops, an error occurred while reporting \(reportedUser.name ?? ""). Please try again or make a bug report."
    }
    
    var blockUserSuccessMessage: String {
        "Successfully blocked \(reportedUser.name ?? "")."
    }
    
    var reportUserSuccessMessage: String {
        "Successfully reported \(reportedUser.name ?? ""). We will investigate that incident."
    }
}
