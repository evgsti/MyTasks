//
//  TaskUpdateView.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskEditView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TaskListViewViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var updatedTitle: String
    @State private var updatedDescription: String
    
    private var task: MyTaskItems
    
    init(viewModel: TaskListViewViewModel, task: MyTaskItems) {
        self.viewModel = viewModel
        self.task = task
        self._updatedTitle = State(initialValue: task.title ?? "")
        self._updatedDescription = State(initialValue: task.descriptionText ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Новое название")) {
                    TextField("Введите название", text: $updatedTitle, axis: .vertical)
                        .focused($isTextFieldFocused)
                }
                
                Section(header: Text("Новое описание")) {
                    TextField("Введите описание", text: $updatedDescription, axis: .vertical)
                        .focused($isTextFieldFocused)
                }
            }
            .navigationTitle("Редактировать")
            .onTapGesture {
                isTextFieldFocused.toggle()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        saveTask()
                        dismiss()
                    }
                    .disabled(updatedTitle.isEmpty && updatedDescription.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveTask() {
        let title = updatedTitle.isEmpty ? "Без названия" : updatedTitle
        let description = updatedDescription.isEmpty ? "Без описания" : updatedDescription
        viewModel.updateTask(task: task, title: title, description: description)
    }
}
