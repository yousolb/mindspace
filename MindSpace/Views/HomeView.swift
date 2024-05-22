//
//  HomeView.swift
//  MindSpace
//
//  Created by yousol bae on 5/11/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage

struct HomeView: View {
    
    @State var profilePic: UIImage?
    @StateObject var viewModel = HomeViewViewModel()
    @State private var offsetY: CGFloat = UIScreen.main.bounds.height*1 / 2
    @State private var isDragging = false
    
    var body: some View {
        
        let bgblue = UIColor(rgb: 0xE9EFFF)
        let lightpink = UIColor(rgb: 0xF0B6B6)
        let darkblue = UIColor(rgb: 0x7A93B4)
        let currentDate = Date()
        let formattedDate = getFormattedDate(date: currentDate)
        let gradient = LinearGradient(gradient: Gradient(colors: [Color(lightpink), Color(darkblue)]), startPoint: .top, endPoint: .bottom)
        
        ZStack {
            
            VStack {
                if let profilePic = self.profilePic {
                    ZStack {
                        Circle()
                            .fill(.gray)
                            .frame(width: 80, height: 80)
                        Image(uiImage: profilePic)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 70, height: 70)
                            .clipped()
                            .foregroundColor(.gray)
                    }
                }
                else {
                    ZStack {
                        Circle()
                            .fill(.gray)
                            .frame(width: 80, height: 80)
                        Circle()
                            .fill(.white)
                            .frame(width: 70, height: 70)
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 70, height: 70)
                            .foregroundColor(.gray)
                    }
                }
            }
            .offset(x: 200, y: 0)
            
            UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 50, topTrailing: 30))
                .fill(gradient)
                .frame(width: 200, height: 100)
                .offset(x: -140, y: 80)
                .shadow(color: .gray, radius: 5, x: 0, y: 8)
                .rotationEffect(.degrees(-10))
            Circle()
                .fill(.black)
                .frame(width: 7, height: 7)
                .offset(x: -60, y: 80)
            Circle()
                .fill(.black)
                .frame(width: 7, height: 7)
                .offset(x: -80, y: 80)
            Ellipse()
                .trim(from: 0, to: 0.5)
                .frame(width: 20, height: 30)
                .offset(x: -70, y: 90)
        
            RoundedRectangle(cornerRadius: 100)
                .fill(Color(lightpink))
                .frame(width: 180, height: 150)
                .padding()
                .offset(x: 90, y: 320)
                .rotationEffect(.degrees(-30))
                .shadow(color: .gray, radius: 5, x: 0, y: 8)
            Circle()
                .fill(.black)
                .frame(width: 9, height: 9)
                .offset(x: 170, y: 230)
            Circle()
                .fill(.black)
                .frame(width: 9, height: 9)
                .offset(x: 200, y: 230)
            SmileCurve()
                .stroke(Color.black, lineWidth: 2)
                .frame(width: 25, height: 20)
                .rotationEffect(.degrees(180))
                .offset(x: 185, y: 245)
            
            RoundedRectangle(cornerRadius: 70)
                .fill(Color(darkblue))
                .frame(width: 240, height: 200)
                .offset(x: -390, y: 120)
                .shadow(color: .gray, radius: 5, x: 0, y: 8)
                .rotationEffect(.degrees(-60))
            Circle()
                .fill(.black)
                .frame(width: 12, height: 12)
                .offset(x: -60, y: 360)
            Circle()
                .fill(.black)
                .frame(width: 12, height: 12)
                .offset(x: -20, y: 360)
            SmileCurve()
                .stroke(Color.black, lineWidth: 2)
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(180))
                .offset(x: -40, y: 380)
            
            Button (action: {
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.white)
                        .frame(width: 70, height: 50)
                    Image(systemName: "arrow.right")
                        .resizable()
                        .frame(width: 30, height: 20)
                        .foregroundColor(.black)
                }
            }
            .offset(x: 210, y: 370)
        
            VStack {
                Text("Today")
                    .font(.custom("Arial Rounded MT Bold", size: 20))
                    .offset(x: -60, y: 20)
                Text(formattedDate)
                    .font(.custom("Arial", size: 20))
                    .offset(x: -15, y: 30)
                if let user = viewModel.user {
                    Text("Hello \(user.name)!")
                        .foregroundColor(.black)
                        .offset(x: 10, y: 180)
                        .font(.custom("Arial Rounded MT Bold", size: 35))
                        .bold()
                }
                else {
                    Text("Loading...")
                        .foregroundColor(.black)
                        .offset(x: 10, y: 180)
                        .font(.custom("Arial Rounded MT Bold", size: 35))
                        .bold()
                }
                Text("How are you feeling today?")
                    .offset(x: 30, y: 200)
                    .font(.custom("Arial", size: 20))
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(Color(bgblue)).edgesIgnoringSafeArea(.all)
        .onAppear {
            fetchPictures()
            viewModel.fetchUser()
        }
        .overlay(
            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 40, height: 6)
                    .padding(10)
                
                ScrollView {
                    VStack {
                        Text("Your Routine")
                            .font(.title)
                            .padding()
                            .offset(x: -90, y: 10)
                        ForEach(0..<20) { i in
                            Text("Item \(i)")
                                .padding()
                            Divider()
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(20)
            }
            .frame(maxWidth: .infinity)
            .offset(y: offsetY)
            .animation(.interactiveSpring(), value: offsetY)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offsetY = max(0, offsetY + value.translation.height)
                    }
                    .onEnded { value in
                        isDragging = false
                        if offsetY > UIScreen.main.bounds.height / 3 {
                            offsetY = UIScreen.main.bounds.height * 1 / 2
                        }
                    }
            )
        )
    }
    
    func fetchPictures() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(currentUser.uid)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                if let userData = try? document.data(as: User.self) {
                    if let profilePictureURL = userData.profilePictureURL {
                        URLSession.shared.dataTask(with: profilePictureURL) { data, response, error in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.profilePic = image
                                }
                            }
                        }.resume()
                    }
                }
            }
        }
    }
}

struct SmileCurve: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        let startPoint = CGPoint(x: 0, y: height / 2)
        let endPoint = CGPoint(x: width, y: height / 2)
        
        let controlPoint = CGPoint(x: width / 2, y: 0)
        
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, control: controlPoint)
        
        return path
    }
}

func getFormattedDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d"
    return dateFormatter.string(from: date)
}


#Preview {
    HomeView()
}
