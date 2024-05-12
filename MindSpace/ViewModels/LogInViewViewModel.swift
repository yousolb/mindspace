//
//  LogInViewViewModel.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import Foundation
import FirebaseAuth

class LogInViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init() {}
    
    func login() {
        guard validate() else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email"
            return false
        }
        guard password.count > 7 else {
            errorMessage = "Please ensure your password has at least 8 characters"
            return false
        }
        
        return true
    }
    
}
