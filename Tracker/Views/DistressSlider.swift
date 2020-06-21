//
//  DistressSlider.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 21/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

class DistressSlider: UISlider {
    
    private var currentValueLabel = UILabel()
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupCurrentValueLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCurrentValueLabel()
    }
    
    
    // MARK: - Setup
    
    private func setupCurrentValueLabel() {
        currentValueLabel.textAlignment = .center
        currentValueLabel.backgroundColor = .clear
        currentValueLabel.textColor = UIColor.black // Thumb is white in both dark/light mode
        addSubview(currentValueLabel)
    }
    
    
    // MARK: - Configuring
    
    private func configureCurrentValueLabel() {
        let trackRect = self.trackRect(forBounds: bounds)
        let bounds = thumbRect(forBounds: self.bounds, trackRect: trackRect, value: value)
        currentValueLabel.frame = bounds
        currentValueLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        currentValueLabel.text = Int(value * 10).description
        currentValueLabel.layer.zPosition = layer.zPosition + 1
    }
    
}
