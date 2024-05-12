//
//  RegisterView.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel = RegisterViewViewModel()
    
    let navyblue = UIColor(rgb: 0x3e405b)
    
    var body: some View {
        NavigationView {
            VStack {
                
                HeaderView(title: "register", desc: "Enter the information you’d like to use to sign into MindSpace")
                
                Form {
                    TextField("Name", text: $viewModel.name)
                        .listRowSeparator(.hidden)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .autocorrectionDisabled()
                    TextField("Email address", text: $viewModel.email)
                        .listRowSeparator(.hidden)
                        .padding()
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    SecureField("Password", text: $viewModel.password)
                        .listRowSeparator(.hidden)
                        .padding()
                        .autocorrectionDisabled()
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    Button {
                        viewModel.register()
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color(navyblue))
                                .shadow(color: Color(navyblue), radius: 3, x: 0, y: 0)
                            Text("Create Account")
                                .bold()
                                .foregroundColor(Color.white)
                                .font(.system(size: 18, weight: .regular, design: .serif))
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.white)
                .offset(y: -80)
                
            }
        }
        
    }
}

#Preview {
    RegisterView()
}
