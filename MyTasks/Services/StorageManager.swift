//
//  StorageManager.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import CoreData

final class StorageManager: ObservableObject {
    
    static let shared = StorageManager()
    
    @Published var tasks: [MyTaskItems] = []
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyTasks")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
        fetchTasks()  // Загружаем задачи при инициализации
    }
    
    // Загрузка всех задач из Core Data
    func fetchTasks() {
        let fetchRequest: NSFetchRequest<MyTaskItems> = MyTaskItems.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            tasks = try viewContext.fetch(fetchRequest)
        } catch let error {
            print("Error fetching tasks: \(error)")
            tasks = []
        }
    }
    // MARK: - CRUD
    // Сохранение задачи в Core Data
    func create(id: UUID, title: String, description: String, isCompleted: Bool, createdAt: Date) {
        let taskEntity = MyTaskItems(context: viewContext)
        taskEntity.id = id
        taskEntity.title = title
        taskEntity.descriptionText = description
        taskEntity.isCompleted = isCompleted
        taskEntity.createdAt = createdAt
        
        saveContext()
        fetchTasks()  // Обновляем список задач
    }
    
    // Обновление задачи
    func update(task: MyTaskItems, newTitle: String, newDescription: String, newCreatedAt: Date) {
        task.title = newTitle
        task.descriptionText = newDescription
        task.createdAt = newCreatedAt
        
        saveContext()
        fetchTasks()  // Обновляем список задач
    }
    
    // Удаление задачи
    func delete(task: MyTaskItems) {
        viewContext.delete(task)
        
        saveContext()
        fetchTasks()  // Обновляем список задач
    }
    
    // Изменение статуса выполнения задачи
    func complitionToggle(task: MyTaskItems) {
        task.isCompleted.toggle()
        
        saveContext()
        fetchTasks()  // Обновляем список задач
    }
    
    // Сохранение изменений в Core Data
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
