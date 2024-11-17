//
//  ToolbarFactory.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskToolbarView: View {
    private let viewModel = TaskListViewViewModel()
    
    let createTask: () -> Void
    
    var body: some View {
        ZStack {
            Text("\(viewModel.tasks.count) \(viewModel.getTaskCountText(count: viewModel.tasks.count))")
                .font(.subheadline)
            HStack {
                Spacer()
                NavigationLink(destination: TaskCreateView(viewModel: viewModel)) {
                    Image(systemName: "square.and.pencil")
                }
                .foregroundStyle(viewModel.disableStatus ? .primary : Color("TintColor"))
                .disabled(viewModel.disableStatus)
            }
        }
    }
}
