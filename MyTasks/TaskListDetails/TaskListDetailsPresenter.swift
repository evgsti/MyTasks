//
//  TaskListDetailsPresenter.swift
//  MyTasks
//
//  Created by Евгений on 20.11.2024.
//

import Foundation

protocol TaskListDetailsPresenterProtocol: AnyObject {
    var task: MyTaskItems { get }
    var title: String { get }
    var description: String { get }
    func updateDescription(description: String)
}

class TaskListDetailsPresenter: TaskListDetailsPresenterProtocol, ObservableObject {
    private let interactor: TaskListDetailsInteractorProtocol

    var task: MyTaskItems

    init(task: MyTaskItems, interactor: TaskListDetailsInteractorProtocol) {
        self.task = task
        self.interactor = interactor
    }

    var title: String {
        task.title ?? "Без названия"
    }
    
    var createdAt: String {
        formattedDateString()
    }

    var description: String {
        task.descriptionText ?? "Без описания"
    }
    
    func formattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: task.createdAt ?? Date())
    }

    func updateDescription(description: String) {
        print("презентер: измененное описание из вью", description)
        print(task.id)

        interactor.updateDescription(task: task, description: description)
    }
}