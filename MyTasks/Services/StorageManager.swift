//
//  StorageManager.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import CoreData

final class StorageManager: ObservableObject {
    
    // MARK: - Public Properties

    static let shared = StorageManager()
    
    var tasks: [MyTaskItems] = []
    
    // MARK: - Private Properties
    
    private let persistentContainer: NSPersistentContainer
    let viewContext: NSManagedObjectContext
    
    // MARK: - Initializer

    init(container: NSPersistentContainer = StorageManager.defaultPersistentContainer()) {
        self.persistentContainer = container
        self.viewContext = persistentContainer.viewContext
    }
    
    // Статический метод для получения стандартного контейнера
    static func defaultPersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "MyTasks")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }
    
    // MARK: - Public Methods

    // Загрузка всех задач из Core Data
    func fetchTasks() -> [MyTaskItems] {
        let fetchRequest: NSFetchRequest<MyTaskItems> = MyTaskItems.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            tasks = try viewContext.fetch(fetchRequest)
            print("менеджер загрузил задачи из Core Data")
        } catch let error {
            print("Error fetching tasks: \(error)")
            tasks = []
        }
        return tasks
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
        
        saveContext(context: viewContext)
        print("менеджер создал задачу \(title)")
        print(viewContext)
    }
    
    func update(task: MyTaskItems, newDescription: String, context: NSManagedObjectContext) {
        print("это новое описание", newDescription)
        task.descriptionText = newDescription
        task.createdAt = Date()
        saveContext(context: context)
//        print("менеджер обновил задачу \(task.id!)")
//        print("менеджер обновил задачу \(task.descriptionText!)")
        
    }
    
    // Удаление задачи
    func delete(task: MyTaskItems) {
        print("менеджер удалил задачу \(task.title!)")
        viewContext.delete(task)
        saveContext(context: viewContext)
    }
    
    // Изменение статуса выполнения задачи
    func complitionToggle(task: MyTaskItems) {
        task.isCompleted.toggle()
        
        saveContext(context: viewContext)
        print("менеджер изменил статус выполнения задачи \(task.title!)")
    }
    
    // MARK: - Private Methods

    // Сохранение изменений в Core Data
    private func saveContext(context: NSManagedObjectContext) {
        print(context)
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
