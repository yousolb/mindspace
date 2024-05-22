//
//  HabitGoalViewViewModel.swift
//  MindSpace
//
//  Created by yousol bae on 5/5/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class HabitGoalViewViewModel: ObservableObject {
    @Published var tasks = []
    @Published var user: User? = nil
    
    init() {}
    
    func toggleDone(task: HabitGoal) {
        var taskCopy = task
        taskCopy.setDone(!taskCopy.completionStatus)
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("tasks")
            .document(taskCopy.id)
            .setData(taskCopy.asDictionary())
    }
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.user = User(id: data["id"] as? String ?? "",
                                  name: data["name"] as? String ?? "",
                                  email: data["email"] as? String ?? "",
                                  joined: data["joined"] as? TimeInterval ?? 0,
                                  tasks: data["tasks"] as? [HabitGoal] ?? [])
            }
        }
    }
    
    func fetchTasks() {
        self.tasks = self.user?.tasks ?? []
    }
}
