//
//  DistressSlider.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 21/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

@IBDesignable
class DistressSlider: UISlider {
    
    private var currentValueLabel = UILabel()
    
    @IBInspectable var currentValuePointSize: CGFloat {
        get {
            return currentValueLabel.font.pointSize
        } set {
            currentValueLabel.font = UIFont.systemFont(ofSize: newValue)
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupCurrentValueLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCurrentValueLabel()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        /// Increases the touch area of the thumb
        return bounds.insetBy(dx: -100, dy: -60).contains(point)
    }
    
    
    // MARK: - Setup
    
    private func setupCurrentValueLabel() {
        currentValueLabel.textAlignment = .center
        currentValueLabel.backgroundColor = .clear
        currentValueLabel.textColor = .black // Thumb is white in both dark/light mode
        addSubview(currentValueLabel)
    }
    
    
    // MARK: - Configuring
    
    private func configureCurrentValueLabel() {
        let trackRect = self.trackRect(forBounds: bounds)
        let bounds = thumbRect(forBounds: self.bounds, trackRect: trackRect, value: value)
        currentValueLabel.frame = bounds
        currentValueLabel.text = Int(value * 10).description
        currentValueLabel.layer.zPosition = layer.zPosition + 1
    }
    
    
    // MARK: - IBDesignable
    
    override init(frame: CGRect) {
        #if !TARGET_INTERFACE_BUILDER
            fatalError("DistressSlider does not support `init(frame:)`. Please initialise from Interface Builder.")
        #else
            super.init(frame: frame)
            value = 0.5
            setupCurrentValueLabel()
            configureCurrentValueLabel()
        #endif
    }
    
}
