//
//  MindSpaceApp.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import SwiftUI
import FirebaseCore

@main
struct MindSpaceApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
