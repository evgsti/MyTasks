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
        VStack(alignment: .leading, spacing: 6) {
            Text(viewModel.title)
                .font(.system(size: 16))
                .lineLimit(4)
                .strikethrough(viewModel.isCompleted)
            Text(viewModel.descriptionText)
                .font(.system(size: 12))
                .lineLimit(10)
            Text(viewModel.formattedDateString())
                .font(.system(size: 12))
                .foregroundStyle(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(width: UIScreen.main.bounds.size.width - 40, alignment: .leading)
    }
}
