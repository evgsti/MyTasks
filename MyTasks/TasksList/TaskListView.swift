//
//  ContentView.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
        
    @State private var showCreateTaskView = false
    @State private var showAlert = false
    
    @ObservedObject var presenter: TaskListPresenter
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            List {
                ForEach(presenter.filteredTasks, id: \.id) { task in
                    TaskRowView(
                        viewModel: TaskRowViewModel(
                            task: task
                        ),
                        link: TaskListDetailsView(
                            presenter: TaskListDetailsPresenter(
                                task: task,
                                interactor: TaskListDetailsInteractor(
                                    storageManager: StorageManager()
                                )
                            ),
                            onSave: {
                                presenter.fetchTasks()
                            }
                        ),
                        action: {
                            presenter.toggleTaskCompletion(task: task)
                        })
                    .contextMenu {
                        TaskContextMenuView(
                            editTask: {
                                
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
                    } preview: {
                        TaskRowPreviewView(viewModel: TaskRowViewModel(task: task))
                    }
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        let taskToDelete = presenter.filteredTasks[index]
                        withAnimation {
                            presenter.deleteTask(task: taskToDelete)
                        }
                    }
                }
                .listSectionSeparator(.hidden, edges: .top)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    TaskToolbarView(
                        viewModel: TaskListToolbarViewModel(
                            tasks: presenter.filteredTasks,
                            disableStatus: presenter.disableStatus
                        ),
                        createTask: {
                            showCreateTaskView.toggle()
                        }
                    )
                }
            }
            .searchable(text: $presenter.searchText, prompt: "Search")
            .disabled(presenter.disableStatus)
            .navigationTitle("Задачи")
            .listStyle(.plain)
            
        }
        .onAppear {
            presenter.fetchTasks()
        }
        .overlay {
            if presenter.isLoading {
                ProgressView("Загрузка...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Ошибка"),
                message: Text(presenter.errorMessage ?? "Произошла неизвестная ошибка"),
                dismissButton: .default(Text("ОК"))
            )
        }
        .sheet(isPresented: $showCreateTaskView) {
            TaskCreateView(presenter: presenter)
                .presentationDetents([.medium, .large])
        }
        .onReceive(presenter.$errorMessage) { error in
            if error != nil {
                showAlert = true
            }
        }
        .tint(Color("TintColor"))
    }
}
