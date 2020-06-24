//
//  DistressPill.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 21/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

/// Extension of `DistressView` that displays the reported distress in a label

@IBDesignable
class DistressPill: DistressView {
    
    private let label = UILabel()
    
    @IBInspectable var fontPointSize: CGFloat {
        get {
            return label.font.pointSize
        } set {
            label.font = UIFont.boldSystemFont(ofSize: newValue)
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLabel()
    }
    
    
    // MARK: - Setup
    
    private func setupLabel() {
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2 * Self.labelPadding).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2 * Self.labelPadding).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: Self.labelPadding).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Self.labelPadding).isActive = true
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)        
        label.textAlignment = .center
        label.textColor = UIColor(named: "Distress Pill Label")
    }
    
    
    // MARK: - Configuring
    
    override func configureForCornerRadius() {
        super.configureForCornerRadius()
        
        label.text = (distress?.description ?? "") + "/10"
    }
    
    
    // MARK: - Helpers
    
    static private let labelPadding: CGFloat = 5
    
    
    // MARK: - IBDesignable
    
    override init(frame: CGRect) {
        #if !TARGET_INTERFACE_BUILDER
            fatalError("DistressPill does not support `init(frame:)`. Please initialise from Interface Builder.")
        #else
            super.init(frame: frame)
            distress = 5
            cornerRadius = 6
            setupLabel()
            label.textColor = .white
        #endif
    }
    
}
