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
                ForEach(presenter.filteredTasks, id: \.id) { task in
                    TaskRowView(task: task, link: TaskListDetailsView(), action: {})
                        .contextMenu {
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
                        } preview: {
                            TaskRowPreviewView(task: task)
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
            .navigationTitle("Задачи")
            .listStyle(.plain)
        }
        .onAppear() {
            print("вью запросило задачи у презентера")
            presenter.getTasks()
        }
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
