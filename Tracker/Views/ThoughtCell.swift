//
//  ThoughtCell.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 21/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

class ThoughtCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet private var distressPill: DistressPill!
    
    var distress: Int? {
        didSet {
            distressPill.distress = distress
        }
    }
    
}
