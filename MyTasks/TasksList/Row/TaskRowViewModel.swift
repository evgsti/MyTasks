//
//  TaskRowViewModel.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import Foundation

final class TaskRowViewModel {
        
    let task: MyTaskItems
        
    init(task: MyTaskItems) {
        self.task = task
    }
    
    var title: String {
        task.title ?? "No Title"
    }
    
    var descriptionText: String {
        task.descriptionText ?? "No description"
    }
    
    var createdAt: Date {
        task.createdAt ?? Date()
    }
    
    var isCompleted: Bool {
        task.isCompleted
    }
        
    func formattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: createdAt)
    }
}
