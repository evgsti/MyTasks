//
//  ContentView.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewViewModel()
    
    @State private var presentCreateAlert = false
    @State private var presentUpdateAlert = false
    
    @State private var newTaskTitle = ""
    @State private var newTaskDescription = ""
    
    @State private var selectedTask: MyTaskItems?
    @State private var updateTaskTitle = ""
    @State private var updateTaskDescription = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredTasks, id: \.id) { task in
                    TaskRowView(
                        task: task,
                        action: {
                            viewModel.toggleTaskCompletion(task: task)
                        }
                    )
                    .contextMenu {
                        TaskContextMenuView(
                            task: task,
                            onEdit: {
                                selectedTask = task
                                updateTaskTitle = task.title ?? ""
                                updateTaskDescription = task.descriptionText ?? ""
                                presentUpdateAlert.toggle()
                                print(task.id!)
                            },
                            onDelete: {
                                withAnimation {
                                    viewModel.deleteTask(task)
                                }
                            }
                        )
                    } preview: {
                        TaskPreviewView(task: task)
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Загрузка...")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Поиск")
            .disabled(viewModel.disableStatus)
            .navigationTitle("Задачи")
            .listStyle(.plain)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    TaskToolbarView(createTask: {
                        presentCreateAlert.toggle()
                    })
                }
            }
            .alert("Добавить задачу", isPresented: $presentCreateAlert) {
                TextField("Название", text: $newTaskTitle)
                TextField("Описание", text: $newTaskDescription)
                
                Button("Сохранить") {
                    let title = newTaskTitle.isEmpty ? "Без названия" : newTaskTitle
                    let description = newTaskDescription.isEmpty ? "Без описания" : newTaskDescription
                    viewModel.createNewTask(
                        title: title,
                        description: description
                    )
                    newTaskTitle.removeAll()
                    newTaskDescription.removeAll()
                }
                .disabled(newTaskTitle.isEmpty && newTaskDescription.isEmpty)
                
                Button("Отмена", role: .cancel) {
                    newTaskTitle.removeAll()
                    newTaskDescription.removeAll()
                }
            }
            .alert("Редактировать задачу", isPresented: $presentUpdateAlert) {
                TextField("Название", text: $updateTaskTitle)
                TextField("Описание", text: $updateTaskDescription)
                
                Button("Сохранить") {
                    if let task = selectedTask {
                        let title = updateTaskTitle.isEmpty ? "Без названия" : updateTaskTitle
                        let description = updateTaskDescription.isEmpty ? "Без описания" : updateTaskDescription
                        withAnimation {
                            viewModel.updateTask(
                                task: task,
                                title: title,
                                description: description
                            )
                        }
                    }
                }
                .disabled(updateTaskTitle.isEmpty && updateTaskDescription.isEmpty)
                
                Button("Отмена", role: .cancel) {
                    newTaskTitle.removeAll()
                    newTaskDescription.removeAll()
                }
            }
        }
    }
}
