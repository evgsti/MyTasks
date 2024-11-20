//
//  TaskListDetailsView.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskListDetailsView: View {
    
    @ObservedObject var presenter: TaskListDetailsPresenter
    
    @State private var editedDescription: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(presenter.createdAt)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.bottom, 15)
            
            // TextEditor для редактирования описания
            TextEditor(text: $editedDescription)
                .padding()
                .frame(height: 200)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .onAppear {
                    // При загрузке экрана устанавливаем текущее описание задачи
                    editedDescription = presenter.description
                }
            
            Spacer()
        }
        .navigationBarTitle(presenter.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Сохраняем изменения при нажатии на кнопку назад
                    presenter.updateDescription(description: editedDescription)
                    print(editedDescription)
                }) {
                    Image(systemName: "chevron.backward")
                    Text("Назад")
                }
            }
        }
        .frame(width: UIScreen.main.bounds.size.width - 40, alignment: .leading)
    }
}
