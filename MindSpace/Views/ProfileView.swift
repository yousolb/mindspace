//
//  ProfileView.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import SwiftUI
import Charts
import Firebase
import FirebaseAuth
import FirebaseStorage

struct ProfileView: View {
    
    @State var bgImagePicker = false
    @State var profilePicker = false
    @State var bgImage: UIImage?
    @State var profilePic: UIImage?
    let lightblue = UIColor(rgb: 0xE9EFFF)
    let navyblue = UIColor(rgb: 0x3e405b)
    @StateObject var viewModel = ProfileViewViewModel()
    let firebaseManager = FirebaseManager.shared
    
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
                    .fullScreenCover(isPresented: $bgImagePicker) {
                        ImagePicker(image: $bgImage)
                            .onDisappear {
                                if let bgImage = self.bgImage {
                                    FirebaseManager.shared.uploadBgPicture(image: bgImage) { url in
                                        if let bgImageURL = url {
                                            FirebaseManager.shared.uploadBgURL(bgImageURL: bgImageURL)
                                        } else {
                                            print("Failed to upload background picture")
                                        }
                                    }
                                }
                            }
                    }
                    .fullScreenCover(isPresented: $profilePicker) {
                        ImagePicker(image: $profilePic)
                            .onDisappear {
                                if let profilePic = self.profilePic {
                                    FirebaseManager.shared.uploadProfilePicture(image: profilePic) { url in
                                        if let profilePictureURL = url {
                                            FirebaseManager.shared.uploadURL(profilePictureURL: profilePictureURL)
                                        } else {
                                            print("Failed to upload profile picture")
                                        }
                                    }
                                }
                            }
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
                .onAppear {
                    fetchPictures()
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
                    
                    if let bgImageURL = userData.bgImageURL {
                        URLSession.shared.dataTask(with: bgImageURL) { data, response, error in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.bgImage = image
                                }
                            }
                        }.resume()
                    }
                }
            }
        }
    }

}

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    
    static let shared = FirebaseManager()
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        super.init()
    }
    
    func uploadProfilePicture(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        let profilePicRef = storage.reference().child("profile_pictures/\(UUID().uuidString).jpg")
        profilePicRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            profilePicRef.downloadURL { (url, error) in
                completion(url)
            }
        }
    }
    
    func uploadURL(profilePictureURL: URL) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }
        let userRef = Firestore.firestore().collection("users").document(currentUser.uid)
        userRef.setData(["profilePictureURL": profilePictureURL.absoluteString], merge: true) { error in
            if let error = error {
                print("Error updating user profile: \(error.localizedDescription)")
            } else {
                print("Profile picture URL updated successfully")
            }
        }
    }
    
    func uploadBgPicture(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        let bgPicRef = storage.reference().child("bg_images/\(UUID().uuidString).jpg")
        bgPicRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            bgPicRef.downloadURL { (url, error) in
                completion(url)
            }
        }
    }
    
    func uploadBgURL(bgImageURL: URL) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }
        let userRef = Firestore.firestore().collection("users").document(currentUser.uid)
        userRef.setData(["bgImageURL": bgImageURL.absoluteString], merge: true) { error in
            if let error = error {
                print("Error updating user profile: \(error.localizedDescription)")
            } else {
                print("Background image URL updated successfully")
            }
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
