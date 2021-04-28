//
//  VerifieHumanDetectorProgressView.swift
//  Verifie
//
//  Created by Misha Torosyan on 4/26/20.
//  Copyright © 2020 Misha Torosyan. All rights reserved.
//

import UIKit

@objc(VerifieHumanDetectorProgressView)

public final class VerifieHumanDetectorProgressView: UIView {
    
    //    MARK: - Public Members
    public var progressColor = UIColor(red: 0.18, green: 0.75, blue: 0.93, alpha: 1.00)
    public var overlayBackgroundColor = UIColor.black {
        didSet {
            redraw()
        }
    }
    
    //    MARK: - Private Members
    private var cutoutRect: CGRect!
    private var progressBorderLayer: CAShapeLayer!
    
    //    MARK: - Internal Members
    var progressAnimationDuration = 0.5
    
    
    //    MARK: - Lifecycle Functions
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        setup()
    }
    

    public override func draw(_ rect: CGRect) {
        
        redraw()
    }
    
    
    
    //    MARK: - Public Functions
    public func set(_ progress: Float) {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressBorderLayer.strokeEnd = CGFloat(progress)
        CATransaction.commit()
    }
    
    
    //    MARK: - Private Functions
    private func redraw() {
        
        cutoutRect = calculateOvalRect()
        layer.sublayers?.removeAll()
        drawOval()
    }
    
    private func setup() {
        
        backgroundColor = .clear
        contentMode = .redraw
    }
    
    private func drawOval() {
        
        let baseLayer = CALayer()
        baseLayer.backgroundColor = overlayBackgroundColor.cgColor
        baseLayer.frame = self.bounds

        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()

        let ellipse = UIBezierPath(ovalIn: cutoutRect)
        rotate(ellipse, degree: 90)

        path.addPath(ellipse.cgPath)
        path.addRect(bounds)

        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

        baseLayer.mask = maskLayer
        
        layer.addSublayer(baseLayer)

        let grayBorderLayer = CAShapeLayer()

        let grayBorderPath = UIBezierPath(ovalIn: cutoutRect)
        rotate(grayBorderPath, degree: -90)
        grayBorderLayer.path = grayBorderPath.cgPath
        grayBorderLayer.lineWidth = 8
        grayBorderLayer.strokeColor = UIColor.gray.cgColor
        grayBorderLayer.frame = bounds
        grayBorderLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(grayBorderLayer)

        let progressBorderLayer = CAShapeLayer()
        let progressBorderPath = UIBezierPath(ovalIn: cutoutRect)
        rotate(progressBorderPath, degree: -90)
        progressBorderLayer.path = progressBorderPath.cgPath
        progressBorderLayer.lineWidth = 8
        progressBorderLayer.strokeColor = progressColor.cgColor
        progressBorderLayer.strokeEnd = 0
        progressBorderLayer.frame = bounds
        progressBorderLayer.lineCap = .round
        progressBorderLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(progressBorderLayer)
        
        self.progressBorderLayer = progressBorderLayer
    }
    
    private func rotate(_ path: UIBezierPath, degree: Double) {
        
        let bounds = path.cgPath.boundingBox
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radians = (degree / 180.0 * Double.pi);
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: CGFloat(radians))
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        
        path.apply(transform)
    }
    
    private func calculateOvalRect() -> CGRect {
        let faceFrameRatio = CGFloat(0.75)
        let topOffsetRatio = CGFloat(0.76)
        let (width, height): (CGFloat, CGFloat)
        
        width = (bounds.width * 1.1)
        height = (width * faceFrameRatio)
        
        let topOffset = ((bounds.height - height) / 2) * topOffsetRatio
        let leftOffset = (bounds.width - width) / 2
        
        return CGRect(x: leftOffset, y: topOffset, width: width, height: height)
    }
}
