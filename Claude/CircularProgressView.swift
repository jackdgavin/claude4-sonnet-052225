//
//  CircularProgressView.swift
//  Claude
//
//  Created by Jack Gavin on 5/22/25.
//


// CircularProgressView.swift
// Custom circular progress indicator for the meditation timer
// Creates a beautiful ring that fills as meditation progresses

import UIKit

class CircularProgressView: UIView {
    
    // MARK: - Properties
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    
    private var progress: CGFloat = 0 {
        didSet {
            updateProgress()
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    // MARK: - Setup
    private func setupLayers() {
        backgroundColor = UIColor.clear
        
        // Track layer (background circle)
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3).cgColor
        trackLayer.lineWidth = 8
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)
        
        // Gradient layer for progress
        gradientLayer.colors = [
            UIColor(red: 0.4, green: 0.6, blue: 0.9, alpha: 1.0).cgColor,
            UIColor(red: 0.6, green: 0.8, blue: 0.95, alpha: 1.0).cgColor,
            UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradientLayer)
        
        // Progress layer
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = 8
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        
        // Add subtle glow effect
        progressLayer.shadowColor = UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 0.8).cgColor
        progressLayer.shadowRadius = 4
        progressLayer.shadowOpacity = 0.6
        progressLayer.shadowOffset = CGSize.zero
        
        gradientLayer.mask = progressLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 20
        
        let startAngle = -CGFloat.pi / 2 // Start from top
        let endAngle = startAngle + 2 * CGFloat.pi
        
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        trackLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
        gradientLayer.frame = bounds
    }
    
    // MARK: - Public Methods
    func setProgress(_ progress: CGFloat, animated: Bool) {
        let clampedProgress = max(0, min(1, progress))
        
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = clampedProgress
            animation.duration = 0.5
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            progressLayer.add(animation, forKey: "progressAnimation")
        }
        
        progressLayer.strokeEnd = clampedProgress
        self.progress = clampedProgress
    }
    
    private func updateProgress() {
        // Additional visual feedback based on progress
        let alpha = 0.3 + (progress * 0.4) // Gradually increase opacity
        progressLayer.shadowOpacity = Float(alpha)
        
        // Subtle color shift as progress increases
        let colorShift = progress * 0.1
        let baseColor = UIColor(red: 0.4 + colorShift, green: 0.6 + colorShift, blue: 0.9, alpha: 1.0)
        
        gradientLayer.colors = [
            baseColor.cgColor,
            UIColor(red: 0.6 + colorShift, green: 0.8, blue: 0.95, alpha: 1.0).cgColor,
            baseColor.cgColor
        ]
    }
    
    // MARK: - Animation Methods
    func pulseAnimation() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.05
        pulseAnimation.duration = 1.0
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.add(pulseAnimation, forKey: "pulseAnimation")
    }
    
    func stopPulseAnimation() {
        layer.removeAnimation(forKey: "pulseAnimation")
    }
}