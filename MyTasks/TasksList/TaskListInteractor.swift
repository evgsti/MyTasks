//
//  TaskListInteractor.swift
//  MyTasks
//
//  Created by Евгений on 19.11.2024.
//

import Foundation

protocol TaskListInteractorProtocol: AnyObject {
    func fetchTasks()
    func deleteTask(task: MyTaskItems)
}

final class TaskListInteractor: TaskListInteractorProtocol {
    @Published var isLoading = false
    @Published var disableStatus = false
    @Published var errorMessage: String? = nil
    @Published var tasks: [MyTaskItems] = []  // Добавьте это свойство
    
    private let storageManager = StorageManager.shared
    private let networkManager = NetworkManager.shared
    
    func deleteTask(task: MyTaskItems) {
        print("интерактор запросил удаление задачи у менеджера")
        storageManager.delete(task: task)
        fetchTasks()
    }
    
    func fetchTasks() {
        print("интерактор запросил задачи у менеджера")
        let hasFetchedDataBefore = UserDefaults.standard.bool(forKey: "hasFetchedDataBefore")
        
        if !hasFetchedDataBefore {
            print("задачи ранее не были загружены")
            isLoading.toggle()
            disableStatus.toggle()
            
            networkManager.fetchData { [weak self] fetchedTasks, error in
                guard let self = self else { return }
                
                UserDefaults.standard.set(true, forKey: "hasFetchedDataBefore")
                self.isLoading.toggle()
                self.disableStatus.toggle()
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                if let fetchedTasks = fetchedTasks {
                    for task in fetchedTasks {
                        self.storageManager.create(
                            id: UUID(),
                            title: task.title,
                            description: task.description ?? "No Description",
                            isCompleted: task.isCompleted ?? false,
                            createdAt: Date()
                        )
                    }
                    // После создания задач обновим локальный массив задач
                    self.tasks = self.storageManager.fetchTasks()
                }
            }
        } else {
            print("задачи ранее были загружены")
            tasks = storageManager.fetchTasks()
        }
    }

}
