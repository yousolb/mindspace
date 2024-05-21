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
            .offset(x: 170, y: 0)
            
            UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 50, topTrailing: 30))
                .fill(gradient)
                .frame(width: 200, height: 100)
                .offset(x: -160, y: 80)
                .shadow(color: .gray, radius: 5, x: 0, y: 8)
                .rotationEffect(.degrees(-10))
            Circle()
                .fill(.black)
                .frame(width: 7, height: 7)
                .offset(x: -90, y: 80)
            Circle()
                .fill(.black)
                .frame(width: 7, height: 7)
                .offset(x: -70, y: 80)
            Ellipse()
                .trim(from: 0, to: 0.5)
                .frame(width: 20, height: 30)
                .offset(x: -80, y: 90)
        
            Blob()
                .fill(Color(lightpink))
                .frame(width: 250, height: 150)
                .padding()
                .offset(x: -40, y: 320)
                .rotationEffect(.degrees(-50))
                .shadow(color: .gray, radius: 5, x: 0, y: 8)
            Circle()
                .fill(.black)
                .frame(width: 9, height: 9)
                .offset(x: 160, y: 230)
            Circle()
                .fill(.black)
                .frame(width: 9, height: 9)
                .offset(x: 190, y: 230)
            SmileCurve()
                .stroke(Color.black, lineWidth: 2)
                .frame(width: 25, height: 20)
                .rotationEffect(.degrees(180))
                .offset(x: 175, y: 245)
            
            RoundedRectangle(cornerRadius: 70)
                .fill(Color(darkblue))
                .frame(width: 240, height: 200)
                .offset(x: -400, y: 100)
                .shadow(color: .gray, radius: 5, x: 0, y: 8)
                .rotationEffect(.degrees(-60))
            Circle()
                .fill(.black)
                .frame(width: 12, height: 12)
                .offset(x: -80, y: 360)
            Circle()
                .fill(.black)
                .frame(width: 12, height: 12)
                .offset(x: -40, y: 360)
            SmileCurve()
                .stroke(Color.black, lineWidth: 2)
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(180))
                .offset(x: -60, y: 380)
            
            Button (action: {
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(.white)
                        .frame(width: 70, height: 50)
                        .offset(x: 180, y: 380)
                    Image(systemName: "arrow.right")
                        .resizable()
                        .offset(x: 180, y: 380)
                        .frame(width: 30, height: 20)
                        .foregroundColor(.black)
                }
            }
        
            VStack {
                Text("Today")
                    .font(.custom("Arial Rounded MT Bold", size: 20))
                    .offset(x: -80, y: 20)
                Text(formattedDate)
                    .font(.custom("Arial", size: 20))
                    .offset(x: -35, y: 30)
                if let user = viewModel.user {
                    Text("Hello \(user.name)!")
                        .foregroundColor(.black)
                        .offset(x: 0, y: 180)
                        .font(.custom("Arial Rounded MT Bold", size: 35))
                        .bold()
                }
                else {
                    Text("Loading...")
                        .foregroundColor(.black)
                        .offset(x: 0, y: 180)
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


struct Blob: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let centerX = rect.midX
        let centerY = rect.midY
        
        let start = CGPoint(x: centerX, y: centerY - height / 2)
        let end = CGPoint(x: centerX, y: centerY + height / 2)
        
        let controlPoint1 = CGPoint(x: centerX + width / 2, y: centerY - height / 2)
        let controlPoint2 = CGPoint(x: centerX + width / 2, y: centerY + height / 2)
        let controlPoint3 = CGPoint(x: centerX - width / 2, y: centerY + height / 2)
        let controlPoint4 = CGPoint(x: centerX - width / 2, y: centerY - height / 2)
        
        path.move(to: start)
        
        path.addCurve(to: end, control1: controlPoint1, control2: controlPoint2)
        path.addCurve(to: start, control1: controlPoint3, control2: controlPoint4)
        
        return path
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

struct Blob2: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let centerX = rect.midX
        let centerY = rect.midY
        
        let controlPointX = width * 0.35
        let controlPointY = height * 0.35
        
        path.move(to: CGPoint(x: centerX, y: centerY - height / 2))
        
        path.addCurve(to: CGPoint(x: centerX + width / 2, y: centerY),
                      control1: CGPoint(x: centerX + controlPointX, y: centerY - height / 2),
                      control2: CGPoint(x: centerX + width / 2, y: centerY - controlPointY))
        
        path.addCurve(to: CGPoint(x: centerX, y: centerY + height / 2),
                      control1: CGPoint(x: centerX + width / 2, y: centerY + controlPointY),
                      control2: CGPoint(x: centerX + controlPointX, y: centerY + height / 2))
        
        path.addCurve(to: CGPoint(x: centerX - width / 2, y: centerY),
                      control1: CGPoint(x: centerX - controlPointX, y: centerY + height / 2),
                      control2: CGPoint(x: centerX - width / 2, y: centerY + controlPointY))
        
        path.addCurve(to: CGPoint(x: centerX, y: centerY - height / 2),
                      control1: CGPoint(x: centerX - width / 2, y: centerY - controlPointY),
                      control2: CGPoint(x: centerX - controlPointX, y: centerY - height / 2))
        
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
