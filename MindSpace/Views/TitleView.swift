//
//  MainView.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import SwiftUI

struct TitleView: View {
    let navyblue = UIColor(rgb: 0x3e405b)
    var body: some View {
        NavigationView {
            VStack {
                Color.white
                Text("mind•space")
                    .offset(y: -250)
                    .foregroundColor(Color(navyblue))
                    .font(.system(size: 30, weight: .medium, design: .serif))
                Text("Individuals need a way to take care of themselves and prioritize their well-being due to the demands of daily life.")
                    .offset(y: -260)
                    .font(.system(size: 18, weight: .regular, design: .serif))
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding()
                NavigationLink("Tap to continue", destination: LogInView())
                    .font(.system(size: 18, weight: .regular, design: .serif))
                    .foregroundColor(Color(navyblue)) //i can't make whole screen navigationlink for some reason
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
