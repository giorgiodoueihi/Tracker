//
//  UIStoryboard+Extensions.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 11/10/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    /// Instantiates a new `UIViewController` as the given class
    ///
    /// - Parameters:
    ///     - type: The class to instantiate
    
    class func instantiate<T>(_ type: T.Type) -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: type)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }

}
