//
//  TaskRow.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskRowView<Destination: View>: View {
    
    private let viewModel = TaskRowViewModel()
    
    var task: MyTaskItems
    var link: Destination
    var action: () -> Void
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .top) {
                Button(action: {
                    action()
                }, label: {
                    Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(task.isCompleted ? Color("TintColor") : .secondary)
                })                
                VStack(alignment: .leading, spacing: 12) {
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
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
            .alignmentGuide(.listRowSeparatorTrailing) { _ in UIScreen.main.bounds.width - 40 }
            
            NavigationLink(destination: link) {
                EmptyView()
            }
            .opacity(0.0)
        }
    }
}
