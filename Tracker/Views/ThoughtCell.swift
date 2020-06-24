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
    @IBOutlet private var distressView: DistressView!
    
    var distress: Int? {
        didSet {
            distressView.distress = distress
        }
    }
    
}
