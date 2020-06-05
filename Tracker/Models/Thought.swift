//
//  Thought.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 5/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import CoreData

@objc(Thought)
class Thought: NSManagedObject {
    
    @NSManaged var identifier: UUID
    @NSManaged var timestamp: Date
    @NSManaged var contents: String
    @NSManaged var distress: Int
    
    convenience init(contents: String, distress: Int) {
        self.init(entity: Thought.entity(), insertInto: PersistenceManager.shared.primaryContext)
        
        self.identifier = UUID()
        self.timestamp = Date()
        self.contents = contents
        self.distress = distress
    }

}
