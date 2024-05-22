//
//  HabitGoal.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import Foundation

enum RepetitionSettings: Codable {
    case nonRepeating
    case daily
    case weekly(daysOfWeek: Set<Int>)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let isNonRepeating = try? container.decode(Bool.self), isNonRepeating {
            self = .nonRepeating
            return
        }
        
        if let daysOfWeek = try? container.decode(Set<Int>.self) {
            self = .weekly(daysOfWeek: daysOfWeek)
            return
        }
        
        self = .daily
    }
}

struct HabitGoal: Codable, Identifiable {
    let id: String
    var name: String
    var date: Date
    var repetitionSettings: RepetitionSettings
    var completionStatus: Bool
    
    mutating func setDone (_ state: Bool) {
        completionStatus = state
    }
    
    func isRepeated(forDate dateToCheck: Date) -> Bool {
        let calendar = Calendar.current
        
        switch repetitionSettings {
        case .daily:
            return true
        case .weekly(let daysOfWeek):
            let dayOfWeekToCheck = calendar.component(.weekday, from: dateToCheck)
            return daysOfWeek.contains(dayOfWeekToCheck)
        case .nonRepeating:
            return false
        }
    }

    private enum CodingKeys: String, CodingKey {
        case name, date, repetitionSettings, completionStatus
    }
    
    init(id: String, name: String, date: Date, repetitionSettings: RepetitionSettings, completionStatus: Bool) {
        self.id = id
        self.name = name
        self.date = date
        self.repetitionSettings = repetitionSettings
        self.completionStatus = completionStatus
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        date = try container.decode(Date.self, forKey: .date)
        
        // Decode repetitionSettings directly from the container
        repetitionSettings = try container.decode(RepetitionSettings.self, forKey: .repetitionSettings)
        
        completionStatus = try container.decode(Bool.self, forKey: .completionStatus)
        id = ""
    }


    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(date, forKey: .date)
        
        // Encode repetitionSettings without passing the encoder
        try container.encode(repetitionSettings, forKey: .repetitionSettings)
        
        try container.encode(completionStatus, forKey: .completionStatus)
    }
}
