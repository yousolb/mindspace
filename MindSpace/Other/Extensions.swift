//
//  Extensions.swift
//  MindSpace
//
//  Created by yousol bae on 5/9/24.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            if let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                return dictionary
            }
        } catch {
            print("Error converting to dictionary: \(error.localizedDescription)")
        }
        return [:]
    }
}
