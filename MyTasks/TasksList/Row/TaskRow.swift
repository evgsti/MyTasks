//
//  TaskRow.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskRowView<Destination: View>: View {
    
    private let viewModel: TaskRowViewModel
    var link: Destination
    var action: () -> Void
    
    init(viewModel: TaskRowViewModel, link: Destination, action: @escaping () -> Void) {
        self.viewModel = viewModel
        self.link = link
        self.action = action
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .top) {
                Button(action: {
                    action()
                }, label: {
                    Image(viewModel.isCompleted ? "check" : "unCheck")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(viewModel.isCompleted ? Color("TintColor") : .secondary)
                })
                .buttonStyle(PlainButtonStyle())
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.title)
                        .font(.system(size: 16))
                        .lineLimit(2)
                        .strikethrough(viewModel.isCompleted)
                    Text(viewModel.descriptionText)
                        .font(.system(size: 12))
                        .lineLimit(2)
                    Text(viewModel.formattedDateString())
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                .foregroundStyle(viewModel.isCompleted ? .secondary : .primary)
            }
            .contentShape(Rectangle())
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
            .alignmentGuide(.listRowSeparatorTrailing) { _ in UIScreen.main.bounds.width - 40 }
            
            NavigationLink(destination: link) {
                EmptyView()
            }
            .opacity(0.0)
        }
    }
}
