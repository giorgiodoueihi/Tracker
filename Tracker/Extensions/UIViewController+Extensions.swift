//
//  UIViewController+Extensions.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 11/10/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

extension UIViewController {

    /// Helper method that performs a `UIStoryboardSegue`
    ///
    /// - Parameters:
    ///     - segue: The `SegueIdentifier` to perform.

    func perform(segue identifier: SegueIdentifier) {
        performSegue(withIdentifier: identifier.rawValue, sender: self)
    }

}
