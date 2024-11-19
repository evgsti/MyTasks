//
//  TaskListInteractor.swift
//  MyTasks
//
//  Created by Евгений on 19.11.2024.
//


protocol TaskListInteractorProtocol: AnyObject {
    func fetchTasks() -> [MyTaskItems]
    func deleteTask(task: MyTaskItems)
}

final class TaskListInteractor: TaskListInteractorProtocol {
        
    private let storageManager = StorageManager.shared
    
    func fetchTasks() -> [MyTaskItems] {
        print("презентер запросил задачи у менеджера")
        return storageManager.tasks
    }
    
    func deleteTask(task: MyTaskItems) {
        print("презентер запросил удаление задачи у менеджера")
        return storageManager.delete(task: task)
    }
}
