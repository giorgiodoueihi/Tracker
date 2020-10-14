//
//  PullToAddThoughtControl.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 14/10/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

class PullToAddThoughtControl: UIRefreshControl {
    
    private let label = UILabel()
    
    
    override init() {
        super.init()
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    
    // MARK: - Setup
    
    private func setupView() {
        tintColor = .init(white: 1, alpha: 0)
        label.text = "+ Add new thought"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemIndigo
        label.textAlignment = .center
        label.numberOfLines = 0
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
