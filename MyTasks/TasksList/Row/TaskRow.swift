//
//  TaskRow.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskRowView: View {
    @StateObject private var viewModel = TaskRowViewModel()
    
    var task: MyTaskItems
    var action: () -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            Button(action: {
                action()
            }, label: {
                Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                    .imageScale(.large)
                    .foregroundStyle(task.isCompleted ? Color("TaskColor") : .gray)
            })
            .buttonStyle(.plain)
            
            VStack(alignment: .leading) {
                Text(task.title ?? "No Title")
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                Text(task.descriptionText ?? "No description")
                    .font(.subheadline)
                Text(viewModel.formattedDateString(from: task.createdAt ?? Date()))
                    .font(.subheadline)
            }
            .foregroundStyle(task.isCompleted ? .gray : .primary)
        }
    }
}
