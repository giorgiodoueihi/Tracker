//
//  PersistenceManager.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 5/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import CoreData

struct PersistenceManager {
    
    static let shared = PersistenceManager()
        
    /// The primary `NSManagedObjectContext` for the app
    let primaryContext: NSManagedObjectContext
    
    
    private init() {
        let container = NSPersistentCloudKitContainer(name: "Tracker")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error: \(error)")
            }
        }
        primaryContext = container.viewContext
    }
    
    
    // MARK: - Actions

    /// Saves the main `NSManagedContext` if changes exist
    
    func saveIfNecessary() {
        if primaryContext.hasChanges {
            try? primaryContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject?) {
        guard let object = object else {
            return
        }
        
        primaryContext.delete(object)
    }
    
    
    // MARK: - Helpers
    
    struct UpdateNotification {
        
        let changedObjects: [NSManagedObject]
        
        
        init(_ notification: Notification) {
            self.changedObjects = [NSInsertedObjectsKey, NSDeletedObjectsKey, NSUpdatedObjectsKey, NSRefreshedObjectsKey].reduce(into: []) { result, key in
                if let set = notification.userInfo?[key] as? Set<NSManagedObject> {
                    result += set
                }
            }
        }
        
    }
    
}
