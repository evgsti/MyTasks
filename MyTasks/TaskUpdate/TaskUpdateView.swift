//
//  TaskUpdateView.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskUpdateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: TaskListViewViewModel
    
    @Binding var task: MyTaskItems?
    
    @State private var updatedTitle: String = ""
    @State private var updatedDescription: String = ""
    
    @FocusState private var isTextFieldFocused: Bool
    
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
            .onAppear {
                if let task = task {
                    updatedTitle = task.title ?? ""
                    updatedDescription = task.descriptionText ?? ""
                }
            }
            .onTapGesture {
                isTextFieldFocused.toggle()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        withAnimation {
                            if let task = task {
                                let title = updatedTitle.isEmpty ? "Без названия" : updatedTitle
                                let description = updatedDescription.isEmpty ? "Без описания" : updatedDescription
                                viewModel.updateTask(task: task, title: title, description: description)
                            }
                        }
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
}
