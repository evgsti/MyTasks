//
//  TaskCreateView.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskCreateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: TaskListViewViewModel
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var newTaskTitle = ""
    @State private var newTaskDescription = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Название", text: $newTaskTitle, axis: .vertical)
                        .focused($isTextFieldFocused)
                    TextField("Описание", text: $newTaskDescription, axis: .vertical)
                        .focused($isTextFieldFocused)
                }
            }
        }
        .onTapGesture {
            isTextFieldFocused.toggle()
        }
        .navigationTitle("Добавить задачу")
        .navigationBarItems(trailing: Button("Готово") {
            saveTask()
        }
            .disabled(newTaskTitle.isEmpty && newTaskDescription.isEmpty)
        )
    }
    
    private func saveTask() {
        let title = newTaskTitle.isEmpty ? "Без названия" : newTaskTitle
        let description = newTaskDescription.isEmpty ? "Без описания" : newTaskDescription
        viewModel.createNewTask(title: title, description: description)
        dismiss()
    }
}
