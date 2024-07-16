//
//  KeyboardViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 15.07.24.
//

import Foundation
import SwiftUI

class KeyboardViewModel: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        DispatchQueue.main.async {
            self.keyboardHeight = keyboardSize.height
        }
    }

    @objc func keyboardWillHide() {
        DispatchQueue.main.async {
            self.keyboardHeight = 0
        }
    }
}
