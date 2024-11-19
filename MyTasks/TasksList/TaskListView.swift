//
//  ContentView.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskListView: View {
    
    // MARK: - Private Properties
    
    @State private var selectedTask: MyTaskItems?
    
    @State private var showCreateTaskView = false
    @State private var showTaskUpdateView = false
    @State private var showAlert = false
    
    @ObservedObject var presenter: TaskListPresenter
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            List {
                taskRows
            }
            .searchable(text: $presenter.searchText, prompt: "Search")
            .disabled(presenter.disableStatus)
            .navigationTitle("Задачи")
            .listStyle(.plain)
        }
        .onAppear {
            print("вью запросило задачи у презентера")
            presenter.fetchTasks()
        }
        .overlay(loadingOverlay)
        .alert(isPresented: $showAlert) {
            errorAlert
        }
        .onReceive(presenter.$errorMessage) { error in
            if error != nil {
                showAlert = true
            }
        }
        .tint(Color("TintColor"))
    }
    
    // MARK: - Subviews
    
    private var taskRows: some View {
        ForEach(presenter.filteredTasks, id: \.id) { task in
            TaskRowView(viewModel: TaskRowViewModel(task: task), link: TaskListDetailsView(), action: {})
                .contextMenu {
                    taskContextMenu(for: task)
                } preview: {
                    TaskRowPreviewView(viewModel: TaskRowViewModel(task: task))
                }
        }
        .onDelete(perform: deleteTask)
        .listSectionSeparator(.hidden, edges: .top)
    }
    
    private func taskContextMenu(for task: MyTaskItems) -> some View {
        TaskContextMenuView(
            updateTask: {
                selectedTask = task
                showTaskUpdateView.toggle()
            },
            shareTask: {
                // Логика для шаринга задачи
            },
            deleteTask: {
                withAnimation {
                    presenter.deleteTask(task: task)
                }
            }
        )
    }
    
    private func deleteTask(at indexSet: IndexSet) {
        if let index = indexSet.first {
            let taskToDelete = presenter.filteredTasks[index]
            withAnimation {
                presenter.deleteTask(task: taskToDelete)
            }
        }
    }
    
    private var loadingOverlay: some View {
        Group {
            if presenter.isLoading {
                ProgressView("Загрузка...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
    }
    
    private var errorAlert: Alert {
        Alert(
            title: Text("Ошибка"),
            message: Text(presenter.errorMessage ?? "Произошла неизвестная ошибка"),
            dismissButton: .default(Text("ОК"))
        )
    }
}

//                    }
//                }
//            }
//            .sheet(isPresented: $showCreateTaskView) {
//                TaskCreateView(viewModel: viewModel)
//                    .presentationDetents([.medium, .large])
//            }
//            .onAppear {
//                print(viewModel.filteredTasks)
//                viewModel.fetchTasks()
//            }
//            .searchable(text: $viewModel.searchText, prompt: "Search")
//            .disabled(viewModel.disableStatus)
//            .navigationTitle("Задачи")
//            .listStyle(.plain)
//            .toolbar {
//                ToolbarItemGroup(placement: .bottomBar) {
//                    TaskToolbarView(createTask: {
//                        showCreateTaskView.toggle()
//                    })
//                }
//            }
//            .overlay {
//                if viewModel.isLoading {
//                    ProgressView("Загрузка...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                }
//            }
//            .alert(isPresented: $showAlert) {
//                Alert(
//                    title: Text("Ошибка"),
//                    message: Text(viewModel.errorMessage ?? "Произошла неизвестная ошибка"),
//                    dismissButton: .default(Text("ОК"))
//                )
//            }
//            .onReceive(viewModel.$errorMessage) { error in
//                if error != nil {
//                    showAlert = true
//                }
//            }
//        }
//        .tint(Color("TintColor"))
//    }
//}
