//
//  SegueManager.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 21/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

struct SegueManager {
    
    static let shared = SegueManager()
    
    enum SegueIdentifier: String {
        case addNewThought
    }
    
    
    func present(_ identifier: SegueIdentifier, controller: UIViewController) {
        controller.performSegue(withIdentifier: identifier.rawValue, sender: nil)
    }
    
}
