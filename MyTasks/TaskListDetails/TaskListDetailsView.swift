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
    
    var onSave: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(presenter.createdAt)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.bottom, 15)
            TextEditor(text: $editedDescription)
                .font(.body)
                .frame(maxWidth: .infinity)
                .autocorrectionDisabled(true)
                .onChange(of: editedDescription) {
                    presenter.debounceUpdateDescription(description: editedDescription, context: viewContext)
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
                    presenter.updateDescription(description: editedDescription, context: viewContext)
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
