//
//  Thought.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 5/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import CoreData

@objc(Thought)
class Thought: NSManagedObject, Dateable, Identifiable {
    
    @NSManaged var identifier: UUID
    @NSManaged var timestamp: Date
    @NSManaged var isoTimestamp: String
    @NSManaged var contents: String
    @NSManaged var distress: Int
    @NSManaged var restructuredThought: RestructuredThought?
    
    /// Initialise a new object with its contents and distress value
    ///
    /// - Parameters:
    ///     - contents: The thought contents
    ///     - distress: The self-reported level of distress (0 to 1, in 0.1 increments)
    
    convenience init(contents: String, distress: Float) {
        self.init(entity: Thought.entity(), insertInto: PersistenceManager.shared.primaryContext)
        
        self.identifier = UUID()
        self.timestamp = Date()
        self.isoTimestamp = convertToYearMonthDayString(date: timestamp)
        self.contents = contents
        self.distress = Int(distress * 10)
    }

}
