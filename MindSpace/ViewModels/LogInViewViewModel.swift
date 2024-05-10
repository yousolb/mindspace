//
//  LogInViewViewModel.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import Foundation

class LogInViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init() {}
    
    func login() {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
    }
    
    func validate() {
    
    }
    
}
