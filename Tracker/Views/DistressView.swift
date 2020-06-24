//
//  DistressView.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 24/6/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

/// Custom `UIView` that changes background based on a given distress rating
///
/// `DistressView` can be extended to add labels, images, buttons, etcetera.

@IBDesignable
class DistressView: UIView {
    
    /// The distress value on a scale from 0-10
    
    var distress: Int? {
        didSet {
            configureForDistress()
        }
    }
    
    /// The corner radius of the view
    ///
    /// Default value is `.zero` (i.e. no radius).
    
    @IBInspectable var cornerRadius: CGFloat = .zero {
        didSet {
            configureForCornerRadius()
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureForCornerRadius()
    }
    
    
    // MARK: - Configuring
    
    func configureForCornerRadius() {
        layer.cornerRadius = cornerRadius
    }
    
    private func configureForDistress() {
        backgroundColor = backgroundColour(distress: distress)
    }
    
    
    // MARK: - Helpers
    
    private func backgroundColour(distress: Int?) -> UIColor {
        guard let distress = distress else {
            return .systemGray // Should never be returned, here just in case :)
        }
        
        switch distress {
        case 0..<4:
            return .systemGray
        case 4..<7:
            return .systemOrange
        default:
            return .systemRed
        }
    }

}
