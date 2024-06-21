//
//  BaseViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 17.06.24.
//

import Foundation
import SwiftUI

enum Status {
    case none, loading, success, failure
}

protocol AlertableViewModel: ObservableObject {
    var showAlert: Bool { get set }
    var alertTitle: String { get set }
    var alertMessage: String { get set }
    var status: Status { get set }
    var resultMessage: String { get set }
    var loadingMessage: String { get set }
    
    func showLoading(message: String)
    func showSuccess(message: String)
    func showFailure(message: String)
    func reset()
    func createAlert(title: String, message: String)
    func dismissAlert()
}

/// super class for all viewmodels used in this project, offers properties
/// and functions to show result or loading messages when user made an action
/// that can possibly fail.
/// Also offers properties for alerts with a title and message depending to the error
class BaseAlertViewModel: AlertableViewModel {
  
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var status: Status = .none
    @Published var resultMessage = ""
    @Published var loadingMessage = ""
    
    func showLoading(message: String) {
        loadingMessage = message
        status = .loading
    }
    
    func showSuccess(message: String) {
        resultMessage = message
        status = .success
    }
    
    func showFailure(message: String) {
        resultMessage = message
        status = .failure
    }
    
    func reset() {
        status = .none
    }
    
    func createAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    func dismissAlert() {
        showAlert = false
        status = .none
    }
    
    ///  function to execute an action delayed, used to avoid cutting off certain animations/transitions
    func executeDelayed(completion: @escaping () -> Void, delay: Double = 1.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion()
        }
    }
}

extension View {
    ///  function to execute an action delayed, used to avoid cutting off certain animations/transitions
    func executeDelayed(completion: @escaping () -> Void, delay: Double = 1.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion()
        }
    }
}
