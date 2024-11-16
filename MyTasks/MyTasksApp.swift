//
//  MyTasksApp.swift
//  MyTasks
//
//  Created by Евгений on 16.11.2024.
//

import SwiftUI

@main
struct MyTasksApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
