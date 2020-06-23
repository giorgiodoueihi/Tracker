//
//  RoundedButton.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 21/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupContentInsets()
        configureRoundedBorderColour()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configureRoundedBorderColour()
        }
    }
    
    
    // MARK: - Setup
    
    private func setupContentInsets() {
        contentEdgeInsets = .init(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    
    // MARK: - Configuring
    
    private func configureRoundedBorderColour() {
        layer.borderColor = titleLabel?.textColor.cgColor
    }
    
    
    // MARK: - IBDesignable
    
    override init(frame: CGRect) {
        #if TARGET_INTERFACE_BUILDER
            super.init(frame: frame)
        #else
            fatalError("RoundedButton does not support `init(frame:)`. Please initialise from Interface Builder.")
        #endif
    }
    
}
