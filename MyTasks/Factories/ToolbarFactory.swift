//
//  ToolbarFactory.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskToolbarView: View {
    @ObservedObject private var viewModel = TaskViewViewModel()
    
    var body: some View {
        ZStack {
            Text("\(viewModel.tasks.count) \(viewModel.getTaskCountText(count: viewModel.tasks.count))")
                .font(.subheadline)
            HStack {
                Spacer()
                Button(action: {
                    print("Trailing navigation bar button pressed")
                }, label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(viewModel.disableStatus ? .primary : Color("TaskColor"))
                }).disabled(viewModel.disableStatus)
            }
        }
    }
}
