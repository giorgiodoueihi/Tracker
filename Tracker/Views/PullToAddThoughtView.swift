//
//  PullToAddThoughtControl.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 14/10/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

@IBDesignable
class PullToAddThoughtView: UIView {
    
    private let label = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .bar)
    private let stackView = UIStackView()
    
    var isDragging: Bool = false
    var progress: Float = 0.0 {
        didSet {
            progressView.progress = progress
            alpha = CGFloat(progress)
            
            label.text = {
                if (0..<2/3).contains(progress) {
                    return "Pull to add thought"
                } else if (2/3..<3/3).contains(progress) {
                    return "Keep pulling!"
                } else {
                    return "Release to add thought"
                }
            }()
            
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        #if !TARGET_INTERFACE_BUILDER
            fatalError("PullToAddThoughtControl does not support `init(frame:)`. Please initialise from Interface Builder.")
        #else
            super.init(frame: frame)            
            setupView()
            progress = 0.5
        #endif
    }
    
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .init(white: 1, alpha: 0)        
        setupStackView()
        setupProgressView()
        setupLabel()
    }
    
    private func setupStackView() {
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setupLabel() {
        label.text = "Pull to add thought"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemIndigo
        label.textAlignment = .center
        label.numberOfLines = 0
        stackView.addArrangedSubview(label)
    }
    
    private func setupProgressView() {
        //stackView.addArrangedSubview(progressView)
    }
    
}
