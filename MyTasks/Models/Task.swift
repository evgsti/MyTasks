//
//  Task.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import Foundation

// Модель для задачи, которая будет использоваться в Core Data
struct Task: Identifiable, Codable {
    
    let id: UUID  // Используем UUID для уникальной идентификации
    let title: String // Заголовок задачи (оставим пустым, если в JSON нет)
    let description: String?  // Описание задачи (из JSON)
    let isCompleted: Bool?  // Статус выполнения (из JSON)
    let createdAt: Date  // Дата создания задачи (сейчас)

    // Инициализатор, где мы по умолчанию заполняем пустое название и текущую дату
    init(description: String, isCompleted: Bool) {
        self.id = UUID()  // Генерация уникального UUID для каждой задачи
        self.title = "No Title" // В JSON нет поля "title", заполняем пустым значением
        self.description = description
        self.isCompleted = isCompleted
        self.createdAt = Date()  // Время создания задачи
    }
}

// Модель для ответа с JSON
struct TodosResponse: Codable {
    let todos: [TaskJSON]  // Массив объектов в JSON, где каждый объект имеет только "todo" и "completed"
}

struct TaskJSON: Codable {
    let todo: String  // Описание задачи
    let completed: Bool  // Статус выполнения задачи
}
