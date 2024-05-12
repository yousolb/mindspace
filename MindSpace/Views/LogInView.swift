//
//  LogInView.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import SwiftUI

struct LogInView: View {
    
    @StateObject var viewModel = LogInViewViewModel()
    
    let navyblue = UIColor(rgb: 0x3e405b)
    
    var body: some View {
            VStack {
                
            HeaderView(title: "mind•space", desc: "Log in with your email and password")
                
            Form {
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                TextField("Email address", text: $viewModel.email)
                    .listRowSeparator(.hidden)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .autocorrectionDisabled()
                SecureField("Password", text: $viewModel.password)
                    .listRowSeparator(.hidden)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .autocorrectionDisabled()
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                Button {
                    viewModel.login()
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(navyblue))
                            .shadow(color: Color(navyblue), radius: 3, x: 0, y: 0)
                        Text("Next")
                            .bold()
                            .foregroundColor(Color.white)
                            .font(.system(size: 18, weight: .regular, design: .serif))
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.white)
            .offset(y: -50)
            
            Spacer()
            
            Button {
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color(navyblue), lineWidth: 1)
                        .foregroundColor(Color.white)
                    NavigationLink("Create an Account",
                                   destination: RegisterView())
                        .foregroundColor(Color(navyblue))
                        .font(.system(size: 15, weight: .regular, design: .serif))
                }
            }
            .frame(width: 320, height: 35)
            
        }
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

#Preview {
    LogInView()
}
