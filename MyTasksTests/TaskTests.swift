//
//  wfsfd.swift
//  MyTasksTests
//
//  Created by Евгений on 18.11.2024.
//

import XCTest
@testable import MyTasks
import CoreData

final class TaskTests: XCTestCase {

    private var persistentContainer: NSPersistentContainer!
    private var storageManager: StorageManager!

    override func setUp() {
        super.setUp()
        
        // Создаем тестовый контейнер для Core Data
        persistentContainer = {
            let container = NSPersistentContainer(name: "MyTasks")
            let description = container.persistentStoreDescriptions.first
            description?.type = NSInMemoryStoreType
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Ошибка загрузки хранилища: \(error)")
                }
            }
            return container
        }()
        
        // Инициализируем StorageManager с тестовым контейнером
        storageManager = StorageManager(container: persistentContainer)
    }
    
    override func tearDown() {
        persistentContainer = nil
        storageManager = nil
        super.tearDown()
    }
    
    // Вспомогательная функция для создания тестовых задач
    private func createTestTask(title: String = "Тестовая задача", description: String = "Описание тестовой задачи", isCompleted: Bool = false) -> MyTaskItems? {
        let testID = UUID()
        storageManager.create(id: testID, title: title, description: description, isCompleted: isCompleted, createdAt: Date())
        
        // Возвращаем задачу, если она была найдена
        return storageManager.fetchTasks().first { $0.id == testID }
    }

    func testFetchDataFromNetwork() {
        let expectation = XCTestExpectation(description: "Load data from network")
        let networkManager = NetworkManager.shared
        
        networkManager.fetchData { tasks, error in
            XCTAssertNil(error, "Ошибка при загрузке данных из сети: \(error?.localizedDescription ?? "")")
            XCTAssertNotNil(tasks, "Задачи не были загружены")
            XCTAssertGreaterThan(tasks?.count ?? 0, 0, "Массив задач пуст")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func testInitInstanceTask() {
        let task = Task(description: "foo", isCompleted: true)
        XCTAssertEqual(task.description, "foo")
        XCTAssertEqual(task.isCompleted, true)
    }

    func testJSONParsing() {
        let jsonString = """
            {
                "todos": [
                    {"id": 1, "todo": "Задача 1", "completed": false},
                    {"id": 2, "todo": "Задача 2", "completed": true}
                ]
            }
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        XCTAssertNoThrow {
            let response = try JSONDecoder().decode(TodosResponse.self, from: jsonData)
            XCTAssertEqual(response.todos.count, 2)
            XCTAssertEqual(response.todos[0].todo, "Задача 1")
            XCTAssertEqual(response.todos[1].completed, true)
        }
    }

    func testSaveDataToCoreData() {
        // Создаем и сохраняем тестовую задачу
        guard let testTask = createTestTask() else {
            XCTFail("Задача не была сохранена в Core Data")
            return
        }
        
        // Проверяем, что задача добавлена в Core Data
        XCTAssertEqual(storageManager.fetchTasks().count, 1, "Количество задач должно быть равно 1")
        
        // Проверяем свойства задачи
        XCTAssertEqual(testTask.title, "Тестовая задача")
        XCTAssertEqual(testTask.descriptionText, "Описание тестовой задачи")
    }

    func testUpdateTaskInCoreData() {
        // Создаем и сохраняем тестовую задачу
        guard let taskToUpdate = createTestTask() else {
            XCTFail("Задача не была сохранена в Core Data")
            return
        }
        
        // Проверяем, что задача добавлена
        XCTAssertEqual(storageManager.fetchTasks().count, 1, "Количество задач должно быть равно 1")
        
        // Обновляем задачу
        let newDescription = "Обновленное описание задачи"
        let context = persistentContainer.viewContext
        
        storageManager.update(task: taskToUpdate, newDescription: newDescription, context: context)
        
        // Проверяем, что задача обновлена
        guard let updatedTask = storageManager.fetchTasks().first else {
            XCTFail("Задача не была обновлена")
            return
        }
        
        XCTAssertEqual(updatedTask.descriptionText, newDescription, "Описание задачи не обновилось")
    }
    
    func testDeleteTaskFromCoreData() {
        // Создаем и сохраняем тестовую задачу
        guard let testTask = createTestTask() else {
            XCTFail("Задача не была сохранена в Core Data")
            return
        }
        
        // Проверяем, что задача добавлена
        XCTAssertEqual(storageManager.fetchTasks().count, 1, "Количество задач должно быть равно 1")
        
        // Удаляем задачу
        storageManager.delete(task: testTask)
        
        // Проверяем, что задача была удалена
        XCTAssertEqual(storageManager.fetchTasks().count, 0, "После удаления задачи количество должно быть равно 0")
    }
}
