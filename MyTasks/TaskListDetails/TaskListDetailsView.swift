//
//  TaskListDetailsView.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskListDetailsView: View {
    private let viewModel = TaskRowViewModel()

    @Environment(\.presentationMode) var presentationMode

    let task: MyTaskItems
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.formattedDateString(from: task.createdAt ?? Date()))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.bottom, 15)
            Text(task.descriptionText ?? "Без описания")
                .font(.body)
            Spacer()
        }
        .navigationBarTitle(task.title ?? "Без названия" )
        .navigationBarBackButtonHidden(true)
        .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                        Text("Назад")
                    }
                }
            }
        .frame(width: UIScreen.main.bounds.size.width - 40, alignment: .leading)
    }
}
