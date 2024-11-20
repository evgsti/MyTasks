//
//  ContextMenuFactory.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskContextMenuView: View {
    
    // MARK: - Public Properties

    let editTask: () -> Void
    let shareTask: () -> Void
    let deleteTask: () -> Void
    
    // MARK: - Body

    var body: some View {
        Button {
            editTask()
        } label: {
            Label("Изменить", systemImage: "square.and.pencil")
        }
        Button {
            shareTask()
        } label: {
            Label("Поделиться", systemImage: "square.and.arrow.up")
        }
        Button(role: .destructive) {
            deleteTask()
        } label: {
            Label("Удалить", systemImage: "trash")
        }
    }
}
