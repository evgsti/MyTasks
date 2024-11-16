//
//  TaskListViewViewModel.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI
import Combine

class TaskViewViewModel: ObservableObject {
    @Published var tasks: [MyTaskItems] = []
    @Published var isLoading = false
    @Published var searchText = ""
    @Published var disableStatus = false
    @Published var error: Error? = nil  // Новое состояние для ошибки
    
    private let storageManager = StorageManager.shared
    private let networkManager = NetworkManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadTasks()
        setupSearchBinding()
    }
    
    var filteredTasks: [MyTaskItems] {
        if searchText.isEmpty {
            return tasks
        } else {
            return tasks.filter { task in
                (task.title ?? "").localizedCaseInsensitiveContains(searchText) ||
                (task.descriptionText ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func toggleTaskCompletion(task: MyTaskItems) {
        storageManager.complitionToggle(task: task)
        fetchTasks()
    }
    
    private func loadTasks() {
        let hasFetchedDataBefore = UserDefaults.standard.bool(forKey: "hasFetchedDataBefore")
        
        if !hasFetchedDataBefore {
            isLoading = true
            disableStatus = true
            
            networkManager.fetchData { [weak self] fetchedTasks, error in
                guard let self = self else { return }
                
                UserDefaults.standard.set(true, forKey: "hasFetchedDataBefore")
                self.isLoading = false
                self.disableStatus = false
                
                if let error = error {
                    self.error = error  // Устанавливаем ошибку
                    return
                }
                
                if let fetchedTasks = fetchedTasks {
                    for task in fetchedTasks {
                        self.storageManager.create(
                            id: UUID(),
                            description: task.description,
                            isCompleted: task.isCompleted
                        )
                    }
                    self.fetchTasks()
                }
            }
        } else {
            fetchTasks()
        }
    }
    
    private func fetchTasks() {
        tasks = storageManager.tasks
    }
    
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.fetchTasks()
            }
            .store(in: &cancellables)
    }
    
    func getTaskCountText(count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
            return "задач"
        }
        
        switch lastDigit {
        case 1:
            return "задача"
        case 2, 3, 4:
            return "задачи"
        default:
            return "задач"
        }
    }
}
