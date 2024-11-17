//
//  ContentView.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskListViewViewModel()
    
    @State private var newTaskTitle = ""
    @State private var newTaskDescription = ""
    
    @State private var selectedTask: MyTaskItems?
    @State private var updateTaskTitle = ""
    @State private var updateTaskDescription = ""
    @State private var openTaskUpdateView = false
    
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
                                editTask: {
                                    selectedTask = task
                                    openTaskUpdateView.toggle()
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
                    if let index = indexSet.first {
                        let taskToDelete = viewModel.filteredTasks[index]
                        withAnimation {
                            viewModel.deleteTask(taskToDelete)
                        }
                    }
                }
            }
            .sheet(item: $selectedTask, content: { task in
                TaskEditView(viewModel: viewModel, task: task)
                    .presentationDetents([.medium, .large])
            })
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
        }
        .tint(Color("TintColor"))
    }
}
