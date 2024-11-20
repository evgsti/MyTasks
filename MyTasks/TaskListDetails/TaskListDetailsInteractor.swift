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
    func debounceUpdateDescription(task: MyTaskItems, description: String, context: NSManagedObjectContext)
}

class TaskListDetailsInteractor: TaskListDetailsInteractorProtocol {
    private let storageManager: StorageManager
    private var debounceWorkItem: DispatchWorkItem?

    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }

    func updateDescription(task: MyTaskItems, description: String, context: NSManagedObjectContext) {
        storageManager.update(task: task, newDescription: description, context: context)
    }

    func debounceUpdateDescription(task: MyTaskItems, description: String, context: NSManagedObjectContext) {
        debounceWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            self.updateDescription(task: task, description: description, context: context)
        }
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
    }
}
