//
//  PlaceholderTextView.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 2/10/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit
import Combine

class PlaceholderTextView: UITextView {
    
    private let placeholderLabel = UILabel()
    private var textPublisher: Cancellable?
    private var notificationCentrePublisher: Cancellable?
    
    @IBInspectable var placeholderText: String? {
        get {
            return placeholderLabel.text
        } set {
            placeholderLabel.text = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupPlaceholderLabel()
        setupPublishers()
    }
    
    
    // MARK: - Setup
    
    private func setupPublishers() {
        textPublisher = publisher(for: \.text)
            .sink(receiveValue: handleTextDidChange)
        notificationCentrePublisher = NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification)
            .sink(receiveValue: handleTextDidChange)
    }
    
    
    // MARK: - Configuring
    
    private func setupPlaceholderLabel() {
        placeholderLabel.textColor = .systemGray
        placeholderLabel.font = .systemFont(ofSize: 17)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.lineBreakMode = .byWordWrapping
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        bringSubviewToFront(placeholderLabel)
        placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        placeholderLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 6).isActive = true
        placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        placeholderLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private var handleTextDidChange: (Any?) -> Void {
        return { [unowned self] object in
            let newValue = (object as? String) ?? self.text
            self.placeholderLabel.isHidden = newValue?.isEmpty == false
        }
    }
    
}
