//
//  TaskListDetailsInteractor.swift
//  MyTasks
//
//  Created by Евгений on 20.11.2024.
//

import Foundation
import CoreData

protocol TaskListDetailsInteractorProtocol {
    func updateDescription(task: MyTaskItems, description: String, context: NSManagedObjectContext)
}

class TaskListDetailsInteractor: TaskListDetailsInteractorProtocol {
    private let storageManager: StorageManager

    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }

    func updateDescription(task: MyTaskItems, description: String, context: NSManagedObjectContext) {
        storageManager.update(task: task, newDescription: description, context: context)
    }
}
