//
//  PreviewFactory.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskPreviewView: View {
    
    // MARK: - Public Properties

    let task: MyTaskItems
    
    // MARK: - Private Properties

    private let viewModel = TaskRowViewModel()
    
    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(task.title ?? "No Title")
                .font(.headline)
                .lineLimit(4)
                .strikethrough(task.isCompleted)
            Text(task.descriptionText ?? "No description")
                .lineLimit(10)
                .font(.subheadline)
            Text(viewModel.formattedDateString(from: task.createdAt ?? Date()))
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .padding(20)
        .frame(width: UIScreen.main.bounds.size.width - 40, alignment: .leading)
    }
}
