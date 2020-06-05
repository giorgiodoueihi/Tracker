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
    ///
    /// You shouldn't really need to communicate with this outside the `PersistenceManager`.
    
    private let primaryContext: NSManagedObjectContext = {
        let container = NSPersistentCloudKitContainer(name: "Tracker")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error: \(error)")
            }
        }
        return container.viewContext
    }()
    
    
    // MARK: - Actions

    /// Saves the main `NSManagedContext` if changes exist
    
    func saveIfNecessary() {
        if primaryContext.hasChanges {
            try? primaryContext.save()
        }
    }
    
    
    // MARK: - Helpers
    
    /// Attempts to create a new `NSFetchedResultsController` from the given parameters
    ///
    /// - Parameters:
    ///     -  type: The NSManagedObject type to fetch
    ///     -  sectionedBy: The object key used to section the controller
    ///     -  sortedBy: The sort descriptors used to order the controller
    
    func fetchedResultsController<T: NSManagedObject>(type: T.Type, sectionedBy section: String?, sortedBy descriptors: [NSSortDescriptor]) -> NSFetchedResultsController<T>? {
        let request = T.fetchRequest()
        request.sortDescriptors = descriptors
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: primaryContext, sectionNameKeyPath: section, cacheName: nil)
        return controller as? NSFetchedResultsController<T>
    }
    
}
