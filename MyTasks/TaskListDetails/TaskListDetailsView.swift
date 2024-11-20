//
//  TaskListDetailsView.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskListDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var presenter: TaskListDetailsPresenter
    
    @State private var editedDescription: String = ""
    @State private var debounceWorkItem: DispatchWorkItem?

    var onSave: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(presenter.createdAt)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.bottom, 15)
            
            // TextEditor для редактирования описания
            TextEditor(text: $editedDescription)
                .font(.body)
                .frame(maxWidth: .infinity)
                .autocorrectionDisabled(true)
                .onChange(of: editedDescription) {
                    debounceUpdateTask()
                }
                .onAppear {
                    editedDescription = presenter.description
                }
            
            Spacer()
        }
        .navigationBarTitle(presenter.title)
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            presenter.updateDescription(description: editedDescription, context: viewContext)
            print("Сохранили описание: \(editedDescription)")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                    onSave?()
                    print(editedDescription)
                }) {
                    Image(systemName: "chevron.backward")
                    Text("Назад")
                }
            }
        }
        .frame(width: UIScreen.main.bounds.size.width - 40, alignment: .leading)
    }
    
    private func debounceUpdateTask() {
            debounceWorkItem?.cancel()
            let workItem = DispatchWorkItem {
                presenter.updateDescription(description: editedDescription, context: viewContext)
            }
            debounceWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
        }
}
