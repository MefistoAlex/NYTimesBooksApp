//
//  CoreDataStack.swift
//  NYTimesBooks
//
//  Created by Alexandr Mefisto on 04.02.2023.
//
import Foundation
import CoreData
final class CoreDataStack {

    // MARK: - Core Data stack

    static var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "NYTimesBooks")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    static func saveContext() {
        let context = CoreDataStack.persistentContainer.viewContext
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
