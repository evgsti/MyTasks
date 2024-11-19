//
//  TaskRowPreview.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskRowPreviewView: View {
    
    // MARK: - Properties

    private let viewModel: TaskRowViewModel
    
    // MARK: - Initialization
    
    init(viewModel: TaskRowViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(viewModel.title)
                .font(.headline)
                .lineLimit(4)
                .strikethrough(viewModel.isCompleted)
            Text(viewModel.descriptionText)
                .lineLimit(10)
                .font(.subheadline)
            Text(viewModel.formattedDateString())
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .padding(20)
        .frame(width: UIScreen.main.bounds.size.width - 40, alignment: .leading)
    }
}
