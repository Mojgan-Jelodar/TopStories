//
//  ActivityIndicator.swift
//  TopStories
//
//  Created by Mozhgan on 8/29/22.
//

import Foundation
import UIKit
final class ActivityIndicator: UIView {
    
    var configuration: Configuration {
        didSet {
            setupViews()
        }
    }
    
    private static let kRotationAnimationKey = "rotationanimationkey"

    init(with configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var trackLayer: CAShapeLayer?
    
    private func setupViews() {
        let trackLayer: CAShapeLayer
        if let initializedTrackLayer = self.trackLayer {
            trackLayer = initializedTrackLayer
        } else {
            trackLayer = .init()
            layer.addSublayer(trackLayer)
            trackLayer.fillColor = UIColor.clear.cgColor
            trackLayer.lineCap = .round
            layoutIfNeeded()
        }
        trackLayer.strokeColor = configuration.color.cgColor
        trackLayer.lineWidth = configuration.lineWidth
        self.trackLayer = trackLayer
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        let startAngle = -CGFloat.pi / 2.0
        let endAngle = CGFloat.pi / 4
        
        let path = UIBezierPath(
            arcCenter: .init(x: frame.width / 2, y: frame.height / 2),
            radius: min(frame.size.width, frame.size.height) / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        trackLayer?.path = path.cgPath
    }
    
    func startAnimating(duration: Double = 0.4) {
        guard layer.animation(forKey: Self.kRotationAnimationKey) == nil else {
            return
        }
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Float.pi * 2.0
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = Float.infinity
        
        layer.add(rotationAnimation, forKey: Self.kRotationAnimationKey)
    }
    
    func stopAnimating() {
        guard layer.animation(forKey: Self.kRotationAnimationKey) != nil else {
            return
        }
        
        layer.removeAnimation(forKey: Self.kRotationAnimationKey)
    }
    
}

extension ActivityIndicator {
    
    struct Configuration {
        var color: UIColor
        var lineWidth: CGFloat
        internal init(
            color: UIColor = .systemBlue,
            lineWidth: CGFloat = 4
        ) {
            self.color = color
            self.lineWidth = lineWidth
        }
    }
    
}
