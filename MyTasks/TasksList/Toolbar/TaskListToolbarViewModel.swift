//
//  Untitled.swift
//  MyTasks
//
//  Created by Евгений on 19.11.2024.
//

import Combine

final class TaskListToolbarViewModel: ObservableObject {
    
    @Published var tasks: [MyTaskItems] = [] {
        didSet {
            tasksCount = tasks.count
        }
    }
    
    @Published var disableStatus: Bool
    @Published private(set) var tasksCount = 0
    
    init(tasks: [MyTaskItems], disableStatus: Bool) {
        self.tasks = tasks
        self.disableStatus = disableStatus
        self.tasksCount = tasks.count
    }
    
    func getTaskCountText() -> String {
        let lastDigit = tasksCount % 10
        let lastTwoDigits = tasksCount % 100
        
        if (lastTwoDigits >= 11 && lastTwoDigits <= 14) || lastDigit == 0 || lastDigit >= 5 {
            return "задач"
        }
        return lastDigit == 1 ? "Задача" : "Задачи"
    }
}
