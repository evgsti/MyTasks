//
//  NetworkManager.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import Foundation
import Network

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let api = "https://dummyjson.com/todos"
    
    private init() {}
    
    // Используем NWPathMonitor для проверки сети
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    // Проверка состояния сети
    private func isConnectedToNetwork(completion: @escaping (Bool) -> Void) {
        monitor.pathUpdateHandler = { path in
            // Передаем результат в замыкание
            completion(path.status == .satisfied)
        }
        
        monitor.start(queue: queue)
    }
    
    func fetchData(completion: @escaping ([Task]?, Error?) -> Void) {
        // Проверка подключения перед выполнением запроса
        isConnectedToNetwork { isAvailable in
            guard isAvailable else {
                DispatchQueue.main.async {
                    completion(nil, NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet connection"]))
                }
                return
            }
            
            guard let url = URL(string: self.api) else { return }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data else {
                    print(error?.localizedDescription ?? "No data received")
                    return
                }
                
                do {
                    // Декодируем JSON в массив TaskJSON
                    let response = try JSONDecoder().decode(TodosResponse.self, from: data)
                    
                    // Маппим JSON в модель CoreDataTask
                    let tasks = response.todos.map { taskJSON in
                        Task(description: taskJSON.todo, isCompleted: taskJSON.completed)
                    }
                    
                    // Передаем задачи в completion на главном потоке
                    DispatchQueue.main.async {
                        completion(tasks, nil)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    print("Error decoding JSON:", error)
                }
            }.resume()
        }
    }
}
