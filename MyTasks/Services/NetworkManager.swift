//
//  NetworkManager.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let api = "https://dummyjson.com/todos"
    
    private init() {}
    
    func fetchData(completion: @escaping ([Task]?, Error?) -> Void) {
        guard let url = URL(string: api) else { return }
        
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
