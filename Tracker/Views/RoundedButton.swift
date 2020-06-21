//
//  RoundedButton.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 21/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupRoundedBorder()
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
    
    private func setupRoundedBorder() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        
    }
    
    
    // MARK: - Configuring
    
    private func configureRoundedBorderColour() {
        layer.borderColor = titleLabel?.textColor.cgColor
    }
    
}
