//
//  TaskRow.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskRowView<Destination: View>: View {
    
    // MARK: - Properties
    
    private let viewModel: TaskRowViewModel
    var link: Destination
    var action: () -> Void
    
    // MARK: - Initialization
    
    init(viewModel: TaskRowViewModel, link: Destination, action: @escaping () -> Void) {
        self.viewModel = viewModel
        self.link = link
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .top) {
                Button(action: {
                    action()
                }, label: {
                    Image(systemName: viewModel.isCompleted ? "checkmark.circle" : "circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(viewModel.isCompleted ? Color("TintColor") : .secondary)
                })
                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.title)
                        .font(.headline)
                        .lineLimit(2)
                        .strikethrough(viewModel.isCompleted)
                    Text(viewModel.descriptionText)
                        .font(.subheadline)
                        .lineLimit(2)
                    Text(viewModel.formattedDateString())
                        .font(.subheadline)
                }
                .foregroundStyle(viewModel.isCompleted ? .secondary : .primary)
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
