//
//  BaseViewModelNSObject.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 18.06.24.
//

import Foundation

class BaseNSViewModel: NSObject, ObservableObject {
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var status: Status = .none
    @Published var resultMessage = ""
    @Published var loadingMessage = ""
    @Published var onAcceptText: String = ""

    var onAcceptAction: (() -> Void)?

    func showLoading(message: String) {
        self.loadingMessage = message
        self.status = .loading
    }

    func showSuccess(message: String) {
        self.resultMessage = message
        self.status = .success
    }

    func showFailure(message: String) {
        self.resultMessage = message
        self.status = .failure
    }

    func reset() {
        self.status = .none
        self.showAlert = false
        self.alertTitle = ""
        self.alertMessage = ""
    }

    func createAlert(title: String, message: String, onAccept: (() -> Void)? = nil, onAcceptText: String = "") {
        alertTitle = title
        alertMessage = message
        onAcceptAction = onAccept
        showAlert = true
        self.onAcceptText = onAcceptText
    }

    func dismissAlert() {
        showAlert = false
        status = .none
        onAcceptAction = nil
        onAcceptText = ""
    }
}
