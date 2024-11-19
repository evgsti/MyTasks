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
            observableInteractor.$isLoading
                .assign(to: \.isLoading, on: self)
                .store(in: &cancellables)
            observableInteractor.$errorMessage
                .assign(to: \.errorMessage, on: self)
                .store(in: &cancellables)
            observableInteractor.$disableStatus
                .assign(to: \.disableStatus, on: self)
                .store(in: &cancellables)
            observableInteractor.$tasks
                .assign(to: \.tasks, on: self)
                .store(in: &cancellables)
        }
    }
    
    func fetchTasks() {
        print("презентер запросил задачи у интерактора")
        interactor.fetchTasks()
    }
    
    func deleteTask(task: MyTaskItems) {
        print("презентер запросил удаление задачи у интерактора")
        interactor.deleteTask(task: task)
        fetchTasks()
    }
    
    func formattedDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
}
