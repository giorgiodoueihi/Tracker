//
//  Dateable.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 18/9/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import Foundation

/// An object that records the date/time it was created
///
/// Objects should conform to `Dateable` when their values benefit from the contextual information
/// provided by a timestamp.
///
/// For example, it is helpful to record the date and time a `Thought` occurred,
/// so that a user may track the change in their thinking over time.

protocol Dateable {
    
    /// The date the object was created
    var timestamp: Date { get set }
    
    /// The object's timestamp as an ISO-8601 formatted string
    ///
    /// Call `Dateable.convertToYearMonthDayString(date:)` to get the correct value.
    
    var isoTimestamp: String { get set }
}

extension Dateable {
    
    /// Converts a `Date` to a `String` in the ISO 8601 (year/month/day) format
    ///
    /// - Parameters:
    ///     - date: The original `Date` object to convert
    
    func convertToYearMonthDayString(date timestamp: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar.current
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter.string(from: timestamp)
    }

}
