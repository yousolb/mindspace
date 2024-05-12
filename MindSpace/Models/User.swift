//
//  User.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
}
