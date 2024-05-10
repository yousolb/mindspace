//
//  RegisterViewViewModel.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import Foundation

class RegisterViewViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    
    init() {}
}
