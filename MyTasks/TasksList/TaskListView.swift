//
//  ContentView.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewViewModel()
    
    @State private var presentUpdateAlert = false
    
    @State private var newTaskTitle = ""
    @State private var newTaskDescription = ""
    
    @State private var selectedTask: MyTaskItems?
    @State private var updateTaskTitle = ""
    @State private var updateTaskDescription = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.filteredTasks, id: \.id) { task in
                    NavigationLink(destination: TaskListDetailsView(task: task)) {
                        TaskRowView(
                            task: task,
                            action: {
                                viewModel.toggleTaskCompletion(task: task)
                            }
                        )
                        .contextMenu {
                            TaskContextMenuView(
                                task: task,
                                editTask: {
                                    selectedTask = task
                                    updateTaskTitle = task.title ?? ""
                                    updateTaskDescription = task.descriptionText ?? ""
                                    presentUpdateAlert.toggle()
                                    print(task.id!)
                                },
                                shareTask: {
                                },
                                deleteTask: {
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
                .onDelete { indexSet in
                    // Удаление задачи по индексу
                    if let index = indexSet.first {
                        let taskToDelete = viewModel.filteredTasks[index]
                        withAnimation {
                            viewModel.deleteTask(taskToDelete)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchTasks()
            }
            .searchable(text: $viewModel.searchText, prompt: "Поиск")
            .disabled(viewModel.disableStatus)
            .navigationTitle("Задачи")
            .listStyle(.plain)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    TaskToolbarView(createTask: {
                    })
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Загрузка...")
                        .progressViewStyle(CircularProgressViewStyle())
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
        .tint(Color("TintColor"))
    }
}
