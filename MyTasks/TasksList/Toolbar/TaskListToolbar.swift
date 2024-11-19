//
//  ToolbarFactory.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskToolbarView: View {
    
    var tasks: [MyTaskItems] = []
    
    // MARK: - Public Properties
    
    let createTask: () -> Void

    // MARK: - Private Properties

    private let viewModel = TaskListToolbarViewModel()
    
    // MARK: - Body

    var body: some View {
        ZStack {
            Text("\(tasks.count) \(viewModel.getTaskCountText(count: tasks.count))")
                .font(.subheadline)
            HStack {
                Spacer()
                Button(action: createTask) {
                    Image(systemName: "square.and.pencil")
                }
//                .foregroundStyle(viewModel.disableStatus ? .primary : Color("TintColor"))
//                .disabled(viewModel.disableStatus)
            }
        }
    }
}
