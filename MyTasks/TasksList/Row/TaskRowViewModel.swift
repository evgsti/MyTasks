//
//  TaskRowViewModel.swift
//  MyTasks
//
//  Created by Евгений on 17.11.2024.
//

import Foundation

final class TaskRowViewModel: ObservableObject {
    func formattedDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
}
