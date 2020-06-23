//
//  DistressPill.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 21/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

@IBDesignable
class DistressPill: UIView {
    
    private let label = UILabel()
    
    @IBInspectable var fontPointSize: CGFloat {
        get {
            return label.font.pointSize
        } set {
            label.font = UIFont.systemFont(ofSize: newValue)
        }
    }
    
    var distress: Int? {
        didSet {
            configureForDistress()
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureRoundedCorners()
    }
    
    
    // MARK: - Setup
    
    private func setupLabel() {
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: label.heightAnchor, multiplier: 2/1).isActive = true
        label.textAlignment = .center
        label.textColor = UIColor(named: "Distress Pill Label")
    }
    
    
    // MARK: - Configuring
    
    private func configureRoundedCorners() {
        layer.cornerRadius = 6
    }
    
    private func configureForDistress() {
        guard let distress = distress else {
            backgroundColor = nil
            return label.text = nil
        }

        backgroundColor = backgroundColour(distress: distress)
        label.text = "\(distress.description)/10"
    }
    
    
    // MARK: - Helpers
    
    private func backgroundColour(distress: Int) -> UIColor {
        switch distress {
        case 0..<4:
            return .systemGray
        case 4..<7:
            return .systemOrange
        default:
            return .systemRed
        }
    }
    
    
    // MARK: - IBDesignable
    
    override init(frame: CGRect) {
        #if !TARGET_INTERFACE_BUILDER
            fatalError("DistressPill does not support `init(frame:)`. Please initialise from Interface Builder.")
        #else
            super.init(frame: frame)
            distress = 5
            setupLabel()
            configureRoundedCorners()
            configureForDistress()
        #endif
    }
    
}
