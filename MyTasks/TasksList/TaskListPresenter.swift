//
//  TaskListPresenter.swift
//  MyTasks
//
//  Created by Евгений on 19.11.2024.
//

import Foundation
import Combine

protocol TaskListPresenterProtocol: AnyObject {
    func deleteTask(task: MyTaskItems)
}

final class TaskListPresenter: TaskListPresenterProtocol, ObservableObject {
    
    @Published var tasks: [MyTaskItems] = []
    @Published var searchText = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var disableStatus: Bool = false
    
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
    
    private var cancellables = Set<AnyCancellable>()
    private let interactor: TaskListInteractorProtocol
    
    init(interactor: TaskListInteractorProtocol) {
        self.interactor = interactor
        
        if let observableInteractor = interactor as? TaskListInteractor {
            observableInteractor.$tasks
                .assign(to: \.tasks, on: self)
                .store(in: &cancellables)
            observableInteractor.$isLoading
                .assign(to: \.isLoading, on: self)
                .store(in: &cancellables)
            observableInteractor.$errorMessage
                .assign(to: \.errorMessage, on: self)
                .store(in: &cancellables)
            observableInteractor.$disableStatus
                .assign(to: \.disableStatus, on: self)
                .store(in: &cancellables)
        }
    }
    
    func fetchTasks() {
        interactor.fetchTasks()
    }
    
    func createTask(title: String, description: String) {
        interactor.createTask(title: title, description: description)
        fetchTasks()
    }
    
    func deleteTask(task: MyTaskItems) {
        interactor.deleteTask(task: task)
        fetchTasks()
    }
    
    func toggleTaskCompletion(task: MyTaskItems) {
        interactor.toggleTaskCompletion(task: task)
        fetchTasks()
    }
}
