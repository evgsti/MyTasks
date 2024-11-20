//
//  ToolbarFactory.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskToolbarView: View {
        
    @ObservedObject var viewModel: TaskListToolbarViewModel
    let createTask: () -> Void
    
    var body: some View {
        ZStack {
            Text("\(viewModel.tasksCount) \(viewModel.getTaskCountText())")
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
