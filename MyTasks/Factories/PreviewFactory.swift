//
//  PreviewFactory.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

struct TaskPreviewView: View {
    @ObservedObject var task: MyTaskItems
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(task.title ?? "No Title")
                .font(.headline)
                .strikethrough(task.isCompleted)
            Text(task.descriptionText ?? "No description")
                .font(.subheadline)
            Text(task.createdAt ?? "")
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .padding(20)
        .frame(width: UIScreen.main.bounds.size.width - 40, alignment: .leading)
        .background(Color("PreviewBackground"))
    }
}

//#Preview {
//    TaskPreviewView()
//}
