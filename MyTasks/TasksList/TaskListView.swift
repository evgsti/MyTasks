//
//  ContentView.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskListView: View {
    
    // MARK: - Private Properties

    @StateObject private var viewModel = TaskListViewViewModel()
    
    @State private var selectedTask: MyTaskItems?
    @State private var showCreateTaskView = false
    @State private var showTaskUpdateView = false
    @State private var showAlert = false
    
    // MARK: - Body
    
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
                                    showTaskUpdateView.toggle()
                                },
                                shareTask: {
                                    // Логика для шаринга задачи
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
                    .listSectionSeparator(.hidden, edges: .top)
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
            .sheet(isPresented: $showCreateTaskView) {
                TaskCreateView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
            .onAppear {
                viewModel.fetchTasks()
            }
            .searchable(text: $viewModel.searchText, prompt: "Search")
            .disabled(viewModel.disableStatus)
            .navigationTitle("Задачи")
            .listStyle(.plain)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    TaskToolbarView(createTask: {
                        showCreateTaskView.toggle()
                    })
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Загрузка...")
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Ошибка"),
                    message: Text(viewModel.errorMessage ?? "Произошла неизвестная ошибка"),
                    dismissButton: .default(Text("ОК"))
                )
            }
            .onReceive(viewModel.$errorMessage) { error in
                if error != nil {
                    showAlert = true
                }
            }
        }
        .tint(Color("TintColor"))
    }
}
