//
//  CharacterSet+Extensions.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 13/10/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import Foundation

extension CharacterSet {
    
    func contains(_ character: Character?) -> Bool {
        return character?.unicodeScalars.allSatisfy(contains(_:)) == true
    }
    
}
