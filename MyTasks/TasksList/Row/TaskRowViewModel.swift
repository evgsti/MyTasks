//
//  TaskRowViewModel.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import Foundation

final class TaskRowViewModel {
    
    // MARK: - Properties
    
    let task: MyTaskItems
    
    // MARK: - Initialization
    
    init(task: MyTaskItems) {
        self.task = task
    }
    
    // MARK: - Computed Properties
    
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
    
    // MARK: - Methods
    
    func formattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: createdAt)
    }
}
