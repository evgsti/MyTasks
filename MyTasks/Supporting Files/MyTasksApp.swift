//
//  MyTasksApp.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

@main
struct testviperApp: App {
    var body: some Scene {
        WindowGroup {
            TaskListView(presenter: TaskListPresenter(interactor: TaskListInteractor()))
        }
    }
}
