//
//  ToolbarFactory.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskToolbarView: View {
    
    // MARK: - Public Properties
    
    let createTask: () -> Void

    // MARK: - Private Properties

    private let viewModel = TaskListViewViewModel()
    
    // MARK: - Body

    var body: some View {
        ZStack {
            Text("\(viewModel.tasks.count) \(viewModel.getTaskCountText(count: viewModel.tasks.count))")
                .font(.subheadline)
            HStack {
                Spacer()
                Button(action: createTask) {
                    Image(systemName: "square.and.pencil")
                }
                .foregroundStyle(viewModel.disableStatus ? .primary : Color("TintColor"))
                .disabled(viewModel.disableStatus)
            }
        }
    }
}
