//
//  RegisterHeaderView.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import SwiftUI

struct RegisterHeaderView: View {
    let navyblue = UIColor(rgb: 0x3e405b)
    var body: some View {
        NavigationView {
            VStack {
                Color.white
                Text("register")
                    .offset(y: -150)
                    .foregroundColor(Color(navyblue))
                    .font(.system(size: 30, weight: .medium, design: .serif))
                Text("Enter the email you’d like to use to sign into MindSpace")
                    .offset(y: -80)
                    .font(.system(size: 18, weight: .regular, design: .serif))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    RegisterHeaderView()
}
