//
//  User.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    var name: String
    let email: String
    let joined: TimeInterval
    var profilePictureURL: URL?
    var bgImageURL: URL?
    var tasks: [HabitGoal]
}
