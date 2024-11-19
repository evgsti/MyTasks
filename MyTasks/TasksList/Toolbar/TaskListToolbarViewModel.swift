//
//  Untitled.swift
//  MyTasks
//
//  Created by Евгений on 19.11.2024.
//

final class TaskListToolbarViewModel {
    
    func getTaskCountText(count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        
        if (lastTwoDigits >= 11 && lastTwoDigits <= 14) || lastDigit == 0 || lastDigit >= 5 {
            return "задач"
        }
        
        return lastDigit == 1 ? "Задача" : "Задачи"
    }
}
