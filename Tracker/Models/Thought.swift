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
    @NSManaged var isoTimestamp: String
    @NSManaged var contents: String
    @NSManaged var distress: Int
    
    
    convenience init(contents: String, distress: Float) {
        self.init(entity: Thought.entity(), insertInto: PersistenceManager.shared.primaryContext)
        
        self.identifier = UUID()
        self.timestamp = Date()
        self.contents = contents
        self.distress = Int(distress * 10)
        self.isoTimestamp = convertToYearMonthDayString(date: timestamp)
    }
    
    
    // MARK: - Helpers
    
    /// Converts a `Date` to a `String` in the year/month/day format
    ///
    /// - Parameters:
    ///     - date: The original `Date` object to convert
    
    private func convertToYearMonthDayString(date timestamp: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        return formatter.string(from: timestamp)
    }

}
