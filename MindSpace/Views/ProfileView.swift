//
//  ProfileView.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import SwiftUI
import Charts

struct ProfileView: View {
    
    @State var bgImagePicker = false
    @State var profilePicker = false
    @State var bgImage: UIImage?
    @State var profilePic: UIImage?
    let lightblue = UIColor(rgb: 0xE9EFFF)
    let navyblue = UIColor(rgb: 0x3e405b)
    @StateObject var viewModel = ProfileViewViewModel()
    
    var orders: [Order] = [
            Order(amount: 10, day: 1),
            Order(amount: 7, day: 2),
            Order(amount: 10, day: 3),
            Order(amount: 13, day: 4),
            Order(amount: 14, day: 5),
            Order(amount: 10, day: 6),
            Order(amount: 16, day: 7)
        ]
    
    var body: some View {
        NavigationView {
            if let user = viewModel.user {
                VStack {
                    ZStack {
                        VStack {
                            if let bgImage = self.bgImage {
                                Image(uiImage: bgImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width, height: 200)
                                    .clipped()
                                    .padding(50)
                            }
                            else {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: UIScreen.main.bounds.width, height: 200)
                                    .padding(50)
                            }
                        }
                        .offset(y: -50)
                        
                        Button(action: {
                            bgImagePicker.toggle()
                        }) {
                            Image(systemName: "photo.badge.plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color(lightblue))
                        }
                        .offset(x: 160, y: 10)
                        
                        VStack {
                            if let profilePic = self.profilePic {
                                ZStack {
                                    Circle()
                                        .fill(Color(lightblue))
                                        .frame(width: 170, height: 170)
                                    Image(uiImage: profilePic)
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 150, height: 150)
                                        .clipped()
                                        .foregroundColor(.gray)
                                }
                            }
                            else {
                                ZStack {
                                    Circle()
                                        .fill(Color(lightblue))
                                        .frame(width: 170, height: 170)
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 150, height: 150)
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 150, height: 150)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .offset(y: 50)
                        
                        Button(action: {
                            profilePicker.toggle()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color(lightblue))
                                    .frame(width: 50, height: 50)
                                Image(systemName: "photo.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                            }
                        }
                        .offset(x: 70, y: 110)
                        
                    }
                    .allowsHitTesting(true)
                    .fullScreenCover(isPresented: $bgImagePicker, onDismiss: nil) {
                        ImagePicker(image: $bgImage)
                    }
                    .fullScreenCover(isPresented: $profilePicker, onDismiss: nil) {
                        ImagePicker(image: $profilePic)
                    }
                    
                    Text(user.name)
                        .foregroundColor(.black)
                        .offset(y:-10)
                        .font(.custom("Verdana", size: 25))
                    Text(user.email)
                        .foregroundColor(.black)
                        .offset(y:0)
                        .font(.custom("Verdana", size: 15))
                    
                    Text("Last Week")
                        .font(.custom("Verdana", size: 20))
                        .offset(x: -80, y: 40)
                    
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Chart {
                                    ForEach(orders) { order in
                                        LineMark(
                                            x: PlottableValue.value("Month", order.day),
                                            y: PlottableValue.value("Orders", order.amount)
                                        )
                                    }
                                }
                                .foregroundColor(Color(navyblue))
                                .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.7)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    .offset(x: 0, y: -10)
                    
                    Button {
                        viewModel.logOut()
                    } label: {
                        Text("Log Out")
                            .foregroundColor(.red)
                    }
                    .offset(y: -20)
                    
                }
            }
            else {
                Text("Profile Loading")
            }
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
}

struct Order: Identifiable {
    var id: String = UUID().uuidString
    var amount: Int
    var day: Int
}

#Preview {
    ProfileView()
}
