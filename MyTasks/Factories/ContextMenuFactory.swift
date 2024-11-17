//
//  ContextMenuFactory.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import SwiftUI

struct TaskContextMenuView: View {
    @ObservedObject var task: MyTaskItems
    
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button {
            onEdit()
        } label: {
            Label("Изменить", systemImage: "square.and.pencil")
        }
        Button(role: .destructive) {
            onDelete()
        } label: {
            Label("Удалить", systemImage: "trash")
        }
    }
}
