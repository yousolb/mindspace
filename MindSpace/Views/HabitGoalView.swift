//
//  HabitGoalView.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import SwiftUI

struct HabitGoalView: View {

    @StateObject var viewModel = HabitGoalViewViewModel()
    private let task: HabitGoal
    
    init(task: HabitGoal) {
        self.task = task
    }
    
    var body: some View {
        HStack {
            Text(task.name)
            Button {
                viewModel.toggleDone(task: self.task)
            } label: {
                Image(systemName: task.completionStatus ? "checkmark.square.fill" : "square")
            }
        }
    }
}

struct HabitGoalView_Previews: PreviewProvider {
    static var previews: some View {
        let habitGoal = HabitGoal(id: "unique", name: "read 100 pages", date: Date(), repetitionSettings: .daily, completionStatus: false)
        
        HabitGoalView(task: habitGoal)
    }
}
