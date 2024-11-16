//
//  NetworkManager.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import Foundation
import SystemConfiguration

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let api = "https://dummyjson.com/todos1"
    
    private init() {}
    
    func fetchData(completion: @escaping ([Task]?, Error?) -> Void) {
        guard isConnectedToNetwork() else {
            // Интернет не доступен
            DispatchQueue.main.async {
                completion(nil, NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No internet connection"]))
            }
            return
        }
        
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
    
    private func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            if flags.contains(.reachable) && !flags.contains(.connectionRequired) {
                return true
            }
        }
        
        return false
    }
}
