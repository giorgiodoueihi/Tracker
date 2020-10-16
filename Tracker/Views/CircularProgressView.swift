//
//  CircularProgressView.swift
//  Tracker
//
//  Created by Giorgio Doueihi on 14/10/20.
//  Copyright © 2020 Giorgio Doueihi. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {
    
    private let contentView = UIView()
    private let circleLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let icon = UIImageView()
    
    var progress: Float = 0 {
        didSet {
            let progress = CGFloat(self.progress)
            let colour: UIColor = progress >= 1.0 ? .systemGreen : .systemIndigo
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            progressLayer.strokeEnd = progress
            progressLayer.strokeColor = colour.cgColor
            icon.tintColor = colour
            alpha = progress
            CATransaction.commit()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupCircularPath()
    }

    
    // MARK: - Setup
    
    private func setupView() {
        alpha = CGFloat(progress)
        setupContentView()
        setupIcon()
        setupCircularPath()
    }
    
    private func setupContentView() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupIcon() {
        icon.image = UIImage(systemName: "plus")
        icon.contentMode = .scaleAspectFit
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        icon.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        icon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    private func setupCircularPath() {
        let centre = CGPoint(x: contentView.frame.size.width / 2, y: contentView.frame.size.height / 2 )
        let lineWidth: CGFloat = 4
        let start = -CGFloat.pi / 2
        let end = 3 * CGFloat.pi / 2
        let circularPath = UIBezierPath(arcCenter: centre, radius: 20, startAngle: start, endAngle: end, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeColor = UIColor.systemGray4.cgColor
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 2.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.systemIndigo.cgColor
        contentView.layer.addSublayer(circleLayer)
        contentView.layer.addSublayer(progressLayer)
    }
    
}
