//
//  TaskListPresenter.swift
//  MyTasks
//
//  Created by Евгений on 19.11.2024.
//

import Foundation
import Combine

protocol TaskListPresenterProtocol: AnyObject {
    var tasks: [MyTaskItems] { get }
    func getTasks()
    func deleteTask(task: MyTaskItems)
}

final class TaskListPresenter: TaskListPresenterProtocol, ObservableObject {
    
    @Published var tasks: [MyTaskItems] = []
    @Published var searchText = ""

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
    
    private let interactor: TaskListInteractorProtocol
    
    init(interactor: TaskListInteractorProtocol) {
        self.interactor = interactor
    }
    
    func getTasks() {
        print("презентер запросил задачи у интерактора")
        tasks = interactor.fetchTasks()
    }
    
    func deleteTask(task: MyTaskItems) {
        print("презентер запросил удаление задачи у интерактора")
        interactor.deleteTask(task: task)
        getTasks()
    }
    
    func formattedDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
}
