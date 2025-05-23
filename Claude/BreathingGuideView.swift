//
//  BreathingGuideView.swift
//  Claude
//
//  Created by Jack Gavin on 5/22/25.
//


// BreathingGuideView.swift
// Animated breathing guide to help users maintain steady breathing rhythm during meditation
// Features gentle pulsing animation that expands and contracts like breathing

import UIKit

class BreathingGuideView: UIView {
    
    // MARK: - Properties
    private let breathingCircle = CAShapeLayer()
    private let outerRing = CAShapeLayer()
    private var isAnimating = false
    
    // Breathing rhythm: 4 seconds in, 4 seconds out
    private let breathingCycleDuration: TimeInterval = 8.0
    
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
        
        // Outer ring (subtle guide)
        outerRing.fillColor = UIColor.clear.cgColor
        outerRing.strokeColor = UIColor(red: 0.7, green: 0.8, blue: 0.9, alpha: 0.2).cgColor
        outerRing.lineWidth = 1.0
        layer.addSublayer(outerRing)
        
        // Main breathing circle
        breathingCircle.fillColor = UIColor(red: 0.6, green: 0.8, blue: 0.95, alpha: 0.3).cgColor
        breathingCircle.strokeColor = UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 0.6).cgColor
        breathingCircle.lineWidth = 2.0
        
        // Add subtle glow
        breathingCircle.shadowColor = UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 0.8).cgColor
        breathingCircle.shadowRadius = 8
        breathingCircle.shadowOpacity = 0.4
        breathingCircle.shadowOffset = CGSize.zero
        
        layer.addSublayer(breathingCircle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePaths()
    }
    
    private func updatePaths() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let baseRadius = min(bounds.width, bounds.height) / 4
        
        // Main breathing circle
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: baseRadius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        breathingCircle.path = circlePath.cgPath
        
        // Outer ring
        let outerRadius = baseRadius * 1.8
        let outerPath = UIBezierPath(
            arcCenter: center,
            radius: outerRadius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        outerRing.path = outerPath.cgPath
    }
    
    // MARK: - Animation Methods
    func startBreathingAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        // Scale animation - breathe in (expand) and breathe out (contract)
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.8
        scaleAnimation.toValue = 1.4
        scaleAnimation.duration = breathingCycleDuration / 2 // Half cycle for in, half for out
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Opacity animation for gentle pulsing effect
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.6
        opacityAnimation.toValue = 1.0
        opacityAnimation.duration = breathingCycleDuration / 2
        opacityAnimation.autoreverses = true
        opacityAnimation.repeatCount = .infinity
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Shadow animation for depth effect
        let shadowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        shadowAnimation.fromValue = 4
        shadowAnimation.toValue = 12
        shadowAnimation.duration = breathingCycleDuration / 2
        shadowAnimation.autoreverses = true
        shadowAnimation.repeatCount = .infinity
        shadowAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Outer ring subtle animation
        let outerScaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        outerScaleAnimation.fromValue = 1.0
        outerScaleAnimation.toValue = 1.1
        outerScaleAnimation.duration = breathingCycleDuration / 2
        outerScaleAnimation.autoreverses = true
        outerScaleAnimation.repeatCount = .infinity
        outerScaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let outerOpacityAnimation = CABasicAnimation(keyPath: "opacity")
        outerOpacityAnimation.fromValue = 0.1
        outerOpacityAnimation.toValue = 0.3
        outerOpacityAnimation.duration = breathingCycleDuration / 2
        outerOpacityAnimation.autoreverses = true
        outerOpacityAnimation.repeatCount = .infinity
        outerOpacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Apply animations
        breathingCircle.add(scaleAnimation, forKey: "breathingScale")
        breathingCircle.add(opacityAnimation, forKey: "breathingOpacity")
        breathingCircle.add(shadowAnimation, forKey: "breathingShadow")
        
        outerRing.add(outerScaleAnimation, forKey: "outerScale")
        outerRing.add(outerOpacityAnimation, forKey: "outerOpacity")
        
        // Add gentle rotation for visual interest
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = breathingCycleDuration * 4 // Slow rotation
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        outerRing.add(rotationAnimation, forKey: "outerRotation")
    }
    
    func stopBreathingAnimation() {
        guard isAnimating else { return }
        isAnimating = false
        
        // Remove all animations
        breathingCircle.removeAllAnimations()
        outerRing.removeAllAnimations()
        
        // Smoothly return to base state
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
        
        breathingCircle.transform = CATransform3DIdentity
        breathingCircle.opacity = 0.6
        breathingCircle.shadowRadius = 8
        
        outerRing.transform = CATransform3DIdentity
        outerRing.opacity = 0.2
        
        CATransaction.commit()
    }
    
    // MARK: - Public Methods
    func setBreathingRate(_ cycleSeconds: TimeInterval) {
        // Allow customization of breathing rate if needed in the future
        // For now, we maintain a steady 8-second cycle (4 in, 4 out)
    }
}