//
//  TaskListDetailsView.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskListDetailsView: View {
    //
    //    // MARK: - Public Properties
    //
    //    @Environment(\.presentationMode) var presentationMode
    //
    //    let task: [Task]
    //
    //    // MARK: - Private Properties
    //
    //    @State private var newTaskDescription: String
    //    @State private var debounceWorkItem: DispatchWorkItem?
    //
    //    private let viewModel = TaskRowViewModel()
    //
    //    // MARK: - Initializer
    //
    //    init(task: Task) {
    //        self.task = task
    //        _newTaskDescription = State(initialValue: task.descriptionText ?? "")
    //    }
    
    // MARK: - Body
    
    var body: some View {
        Text("Hello, World!")
        //        VStack(alignment: .leading) {
        //            Text(viewModel.formattedDateString(from: task.createdAt ?? Date()))
        //                .font(.subheadline)
        //                .foregroundStyle(.secondary)
        //                .padding(.bottom, 15)
        //
        //            TextEditor(text: $newTaskDescription)
        //                .font(.body)
        //                .frame(maxWidth: .infinity)
        //                .autocorrectionDisabled(true)
        //                .onChange(of: newTaskDescription) {
        //                    debounceUpdateTask()
        //                }
        //
        //            Spacer()
        //        }
        //        .navigationBarTitle(task.title ?? "Без названия")
        //        .navigationBarBackButtonHidden(true)
        //        .toolbar {
        //            ToolbarItem(placement: .navigationBarLeading) {
        //                Button(action: handleBackButtonTap) {
        //                    Image(systemName: "chevron.backward")
        //                    Text("Назад")
        //                }
        //            }
        //        }
        //        .frame(width: UIScreen.main.bounds.size.width - 40, alignment: .leading)
        //    }
        //
        //    // MARK: - Private Methods
        //
        //    private func debounceUpdateTask() {
        //        debounceWorkItem?.cancel()
        //        let workItem = DispatchWorkItem {
        //            viewModel.updateTask(task: task, description: newTaskDescription)
        //        }
        //        debounceWorkItem = workItem
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
        //    }
        //
        //    private func handleBackButtonTap() {
        //        presentationMode.wrappedValue.dismiss()
        //        viewModel.updateTask(task: task, description: newTaskDescription)
        //    }
    }
}
