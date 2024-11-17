//
//  ContentView.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewViewModel()
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                            },
                            onDelete: {
                                viewModel.deleteTask(task)
                            }
                        )
                    } preview: {
                        TaskPreviewView(task: task)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Поиск")
            .disabled(viewModel.disableStatus)
            .navigationTitle("Задачи")
            .listStyle(.plain)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    TaskToolbarView()
                }
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Загрузка...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Ошибка"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onReceive(viewModel.$error) { error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}

#Preview {
    TaskListView()
}
