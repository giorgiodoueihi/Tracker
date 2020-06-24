//
//  SegueIdentifier.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 21/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

/// Specifies a `UIStoryboardSegue identifier`
///
/// Allows view controllers to perform segues without interacting with `String`.

enum SegueIdentifier: String {
    case addNewThought
    case editThought
}

extension UIViewController {

    /// Helper method that performs a `UIStoryboardSegue`
    ///
    /// - Parameters:
    ///     - identifier: The `SegueIdentifier` to perform.

    func performViewControllerSegue(identifier: SegueIdentifier) {
        performSegue(withIdentifier: identifier.rawValue, sender: self)
    }

}

extension UIStoryboardSegue {

    /// Helper variable that returns a `SegueIdentifier` object rather than a `String`

    var segueIdentifier: SegueIdentifier? {
        guard let identifier = identifier else {
            return nil
        }

        return SegueIdentifier(rawValue: identifier)
    }
    
}
