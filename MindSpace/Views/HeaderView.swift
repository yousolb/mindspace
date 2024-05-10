//
//  HeaderView.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let desc: String
    let navyblue = UIColor(rgb: 0x3e405b)
    var body: some View {
        NavigationView {
            VStack {
                Color.white
                Text(title)
                    .offset(y: -150)
                    .foregroundColor(Color(navyblue))
                    .font(.system(size: 30, weight: .medium, design: .serif))
                Text(desc)
                    .offset(y: -80)
                    .font(.system(size: 18, weight: .regular, design: .serif))
                    .padding()
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    HeaderView(title: "mind•space", desc: "Log in with your email and password")
}
