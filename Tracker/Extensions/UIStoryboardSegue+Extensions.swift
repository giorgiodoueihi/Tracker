//
//  UIStoryboardSegue+Extensions.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 11/10/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

extension UIStoryboardSegue {

    /// Helper variable that returns `identifier` as a `SegueIdentifier`
    ///
    /// This prevents working with `String` types, which is never safe.

    var segueIdentifier: SegueIdentifier? {
        guard let identifier = identifier else {
            return nil
        }

        return SegueIdentifier(rawValue: identifier)
    }
    
    /// Helper method that forcefully unwraps the segue's destination as the given class
    ///
    /// - Parameters:
    ///     - type: The class to unwrap
    
    func destination<T>(as type: T.Type) -> T {
        return destination as! T
    }
    
}
