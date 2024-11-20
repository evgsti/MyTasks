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
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .padding(.bottom, 16)
            TextEditor(text: $editedDescription)
                .font(.system(size: 16))
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
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                    onSave?()
                    presenter.updateDescription(description: editedDescription, context: viewContext)
                }) {
                    Image(systemName: "chevron.backward")
                    Text("Назад")
                }
            }
        }
        .frame(width: UIScreen.main.bounds.size.width - 40, alignment: .leading)
    }
}
