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
    @IBOutlet private var titleLabelLeadingConstraint: NSLayoutConstraint!
    
    var distress: Int? {
        didSet {
            distressView.distress = distress
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        configureTitleLabelLeadingConstraint(isEditing: editing)
        UIView.animate(withDuration: 0.25) {
            self.configureDistressView(isEditing: editing)
            self.layoutIfNeeded()
        }
    }
    
    
    // MARK: - Configuring
    
    private func configureTitleLabelLeadingConstraint(isEditing editing: Bool) {
        titleLabelLeadingConstraint.constant = editing ? -distressView.frame.width : 15
        setNeedsUpdateConstraints()
    }
    
    private func configureDistressView(isEditing editing: Bool) {
        distressView.alpha = editing ? 0 : 1
    }
    
}
