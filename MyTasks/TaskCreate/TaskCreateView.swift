////  TaskCreateView.swift
////  MyTasks
////
////  Created by Евгений on 17.11.2024.
////
//
//import SwiftUI
//
//struct TaskCreateView: View {
//    
//    // MARK: - Public Properties
//    
//    @ObservedObject var viewModel: TaskListViewViewModel
//
//    // MARK: - Private Properties
//
//    @Environment(\.dismiss) private var dismiss
//    
//    @FocusState private var isTextFieldFocused: Bool
//    
//    @State private var newTaskTitle = ""
//    @State private var newTaskDescription = ""
//    
//    // MARK: - Body
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section {
//                    TextField("Название", text: $newTaskTitle, axis: .vertical)
//                        .focused($isTextFieldFocused)
//                    TextField("Описание", text: $newTaskDescription, axis: .vertical)
//                        .focused($isTextFieldFocused)
//                }
//            }
//            .navigationTitle("Новая задача")
//            .onTapGesture {
//                isTextFieldFocused.toggle()
//            }
//            .toolbar {
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Сохранить") {
//                        withAnimation {
//                            let title = newTaskTitle.isEmpty ? "Без названия" : newTaskTitle
//                            let description = newTaskDescription.isEmpty ? "Без описания" : newTaskDescription
//                            viewModel.createNewTask(title: title, description: description)
//                        }
//                        dismiss()
//                    }
//                    .disabled(newTaskTitle.isEmpty && newTaskDescription.isEmpty)
//                }
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Отмена") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//}
