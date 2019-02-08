//
//  CoreDataManager.swift
//  Stocks
//
//  Created by Kevin Nguyen on 1/7/19.
//  Copyright © 2019 Kevin Nguyen. All rights reserved.
//

import Foundation
import CoreData

typealias PersistentStoreCompletion = () -> Void

class CoreDataManager {
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Stocks")
    }
    
    func loadPersistentStore(description: NSPersistentStoreDescription?, completion: PersistentStoreCompletion?) {
        if let description = description {
            persistentContainer.persistentStoreDescriptions = [description]
        }
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            self.viewContext.automaticallyMergesChangesFromParent = true
            completion?()
        }
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func saveViewContext() {
        save(context: viewContext)
    }
    
    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
