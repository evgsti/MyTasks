//
//  TaskListDetailsInteractor.swift
//  MyTasks
//
//  Created by Евгений on 20.11.2024.
//

import Foundation

protocol TaskListDetailsInteractorProtocol {
    func updateDescription(task: MyTaskItems, description: String)
}

class TaskListDetailsInteractor: TaskListDetailsInteractorProtocol {
    private let storageManager: StorageManager

    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }

    func updateDescription(task: MyTaskItems, description: String) {
        print("Интерактор: измененное описание из презентера", description)
        print(task.id)
        storageManager.update(task: task, newDescription: description)
    }
}
