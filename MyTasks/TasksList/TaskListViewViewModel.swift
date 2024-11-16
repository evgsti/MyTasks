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
    
    private let storageManager = StorageManager.shared
    private let networkManager = NetworkManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadTasks()
        setupSearchBinding()
    }
    
    // Метод для фильтрации задач по тексту поиска
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
    
    // Метод для переключения состояния задачи (выполнено/не выполнено)
    func toggleTaskCompletion(task: MyTaskItems) {
        storageManager.complitionToggle(task: task)
        fetchTasks()  // Обновляем список задач после изменения
    }
    
    // Метод для загрузки задач из сети или Core Data
    private func loadTasks() {
        let hasFetchedDataBefore = UserDefaults.standard.bool(forKey: "hasFetchedDataBefore")
        
        if !hasFetchedDataBefore {
            isLoading = true
            disableStatus = true
            
            // Загрузка данных из сети
            networkManager.fetchData { [weak self] fetchedTasks, error in
                guard let self = self else { return }
                
                UserDefaults.standard.set(true, forKey: "hasFetchedDataBefore")
                self.isLoading = false
                self.disableStatus = false
                
                if let error = error {
                    print("Error loading data: \(error.localizedDescription)")
                    return
                }
                
                if let fetchedTasks = fetchedTasks {
                    // Сохраняем задачи в Core Data
                    for task in fetchedTasks {
                        self.storageManager.create(
                            id: UUID(),
                            description: task.description,
                            isCompleted: task.isCompleted
                        )
                    }
                    self.fetchTasks()  // Обновляем список задач после добавления
                }
            }
        } else {
            // Если данные уже были загружены, просто загружаем их из Core Data
            fetchTasks()
        }
    }
    
    // Метод для загрузки задач из Core Data
    private func fetchTasks() {
        tasks = storageManager.tasks
    }
    
    // Настройка связи поиска
    private func setupSearchBinding() {
        // Подписка на изменение текста поиска
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.fetchTasks() // Обновляем задачи при изменении текста поиска
            }
            .store(in: &cancellables)
    }
    
    // Метод для получения правильной формы слова "задача"
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
