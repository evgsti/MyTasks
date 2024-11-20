//
//  TaskListInteractor.swift
//  MyTasks
//
//  Created by Евгений on 19.11.2024.
//

import Foundation

protocol TaskListInteractorProtocol: AnyObject {
    func fetchTasks()
    func createTask(title: String, description: String)
    func deleteTask(task: MyTaskItems)
    func toggleTaskCompletion(task: MyTaskItems)
}

final class TaskListInteractor: TaskListInteractorProtocol {
    
    @Published var isLoading = false
    @Published var disableStatus = false
    @Published var errorMessage: String? = nil
    @Published var tasks: [MyTaskItems] = []
    
    private let storageManager = StorageManager.shared
    private let networkManager = NetworkManager.shared
    
    func fetchTasks() {
        let hasFetchedDataBefore = UserDefaults.standard.bool(forKey: "hasFetchedDataBefore")
        
        if !hasFetchedDataBefore {
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
                    self.tasks = self.storageManager.fetchTasks()
                }
            }
        } else {
            tasks = storageManager.fetchTasks()
        }
    }
    
    func createTask(title: String, description: String) {
            storageManager.create(
                id: UUID(),
                title: title,
                description: description,
                isCompleted: false,
                createdAt: Date()
            )
            fetchTasks()
        }

    func deleteTask(task: MyTaskItems) {
        storageManager.delete(task: task)
        fetchTasks()
    }
    
    func toggleTaskCompletion(task: MyTaskItems) {
        storageManager.complitionToggle(task: task)
        fetchTasks()
    }
}
