//
//  TaskRow.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskRowView: View {
    private let viewModel = TaskRowViewModel()
    
    var task: MyTaskItems
    var action: () -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            Button(action: {
                action()
            }, label: {
                Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                    .imageScale(.large)
                    .foregroundStyle(task.isCompleted ? Color("TintColor") : .secondary)
            })
            .buttonStyle(.plain)
            
            VStack(alignment: .leading) {
                Text(task.title ?? "No Title")
                    .font(.headline)
                    .lineLimit(2)
                    .strikethrough(task.isCompleted)
                Text(task.descriptionText ?? "No description")
                    .font(.subheadline)
                    .lineLimit(2)
                Text(viewModel.formattedDateString(from: task.createdAt ?? Date()))
                    .font(.subheadline)
            }
            .foregroundStyle(task.isCompleted ? .secondary : .primary)
        }
    }
}
