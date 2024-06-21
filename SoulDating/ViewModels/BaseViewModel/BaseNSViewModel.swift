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
    
    func showLoading(message: String) {
        DispatchQueue.main.async {
            self.loadingMessage = message
            self.status = .loading
        }
    }
    
    func showSuccess(message: String) {
        DispatchQueue.main.async {
            self.resultMessage = message
            self.status = .success
        }
    }
    
    func showFailure(message: String) {
        DispatchQueue.main.async {
            self.resultMessage = message
            self.status = .failure
        }
    }
    
    func reset() {
        DispatchQueue.main.async {
            self.status = .none
            self.showAlert = false
            self.alertTitle = ""
            self.alertMessage = ""
        }
    }
    
    func createAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.alertTitle = title
            self.alertMessage = message
            self.showAlert = true
        }
    }
    
    func dismissAlert() {
        DispatchQueue.main.async {
            self.showAlert = false
        }
    }
}
