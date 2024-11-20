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
            Label("Редактировать", image: "edit")
        }
        Button {
            shareTask()
        } label: {
            Label("Поделиться", image: "share")
        }
        Button(role: .destructive) {
            deleteTask()
        } label: {
            Label("Удалить", image: "trash")
        }
    }
}
