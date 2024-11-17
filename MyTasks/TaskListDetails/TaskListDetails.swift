//
//  TaskListDetails.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskListDetailsView: View {
    let task: MyTaskItems
    private let viewModel = TaskRowViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(viewModel.formattedDateString(from: task.createdAt ?? Date()))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(task.descriptionText ?? "Без описания")
                .font(.body)
            Spacer()
        }
        .navigationBarTitle(task.title ?? "Без названия" )
        .frame(width: UIScreen.main.bounds.size.width - 40, alignment: .leading)
    }
}
