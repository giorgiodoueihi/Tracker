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
    case restructureThought
    case viewThoughtDetail
}
