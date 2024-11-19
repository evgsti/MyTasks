//
//  TaskRowViewModel.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import Foundation

final class TaskRowViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    private let storageManager = StorageManager.shared

    // MARK: - Public Methods

    func formattedDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
    
    func updateTask(task: MyTaskItems, description: String) {
        storageManager.update(
            task: task,
            newDescription: description,
            newCreatedAt: Date()
        )
    }
}
