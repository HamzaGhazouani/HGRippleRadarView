//
//  RippleView.swift
//  HGNearbyUsers_Example
//
//  Created by Hamza Ghazouani on 23/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit


/// A view with ripple animation

@IBDesignable
public class RippleView: UIView {
    
    // MARK: Private Properties
    
    /// the center circle used for the scale animation
    private var centerAnimatedLayer: CAShapeLayer!
    
    /// the center disk point
    private var diskLayer: CAShapeLayer!
    
    /// The duration to animate the central disk
    private var centerAnimationDuration: CFTimeInterval {
        return CFTimeInterval(animationDuration) * 0.90
    }
    
    /// The duration to animate one circle
    private var circleAnimationDuration: CFTimeInterval {
        if circlesLayer.count ==  0 {
            return CFTimeInterval(animationDuration)
        }
        return CFTimeInterval(animationDuration) / CFTimeInterval(circlesLayer.count)
    }
    
    /// The timer used to start / stop circles animation
    private var circlesAnimationTimer: Timer?
    
    /// The timer used to start / stop disk animation
    private var diskAnimationTimer: Timer?
    
    // MARK: Internal properties
    
    /// The maximum possible radius of circle
    var maxCircleRadius: CGFloat {
        if numberOfCircles == 0 {
            return min(bounds.midX, bounds.midY)
        }
        return (circlesPadding * CGFloat(numberOfCircles - 1) + minimumCircleRadius)
    }
    
    /// the circles surrounding the disk
    var circlesLayer = [CAShapeLayer]()
    
    /// The padding between circles
    var circlesPadding: CGFloat {
        if paddingBetweenCircles != -1 {
            return paddingBetweenCircles
        }
        let availableRadius = min(bounds.width, bounds.height)/2 - (minimumCircleRadius)
        return  availableRadius / CGFloat(numberOfCircles)
    }
    
    // MARK: Public Properties
    
    /// The radius of the disk in the view center, the default value is 5
    @IBInspectable public var diskRadius: CGFloat = 5 {
        didSet {
            redrawDisks()
            redrawCircles()
        }
    }
    
    /// The color of the disk in the view center, the default value is ripplePink color
    @IBInspectable public var diskColor: UIColor = .ripplePink {
        didSet {
            diskLayer.fillColor = diskColor.cgColor
            centerAnimatedLayer.fillColor = diskColor.cgColor
        }
    }
    
    /// The number of circles to draw around the disk, the default value is 3, if the forcedMaximumCircleRadius is used the number of drawn circles could be less than numberOfCircles
    @IBInspectable public var numberOfCircles: Int = 3 {
        didSet {
            redrawCircles()
        }
    }
    
    /// The padding between circles
    @IBInspectable public var paddingBetweenCircles: CGFloat = -1 {
        didSet {
            redrawCircles()
        }
    }
    
    /// The color of the off status of the circle, used for animation
    @IBInspectable public var circleOffColor: UIColor = .rippleDark {
        didSet {
            circlesLayer.forEach {
                $0.strokeColor = circleOffColor.cgColor
            }
        }
    }
    
    /// The color of the on status of the circle, used for animation
    @IBInspectable public var circleOnColor: UIColor = .rippleWhite
    
    /// The minimum radius of circles, used to make space between the disk and the first circle, the radius must be grather than 5px , because if not the first circle will not be shown, the default value is 10, it's recommanded to use a value grather than the disk radius if you would like to show circles outside disk
    @IBInspectable public var minimumCircleRadius: CGFloat = 10 {
        didSet {
            if minimumCircleRadius < 5 {
                minimumCircleRadius = 5
            }
            redrawCircles()
        }
    }
    
    /// The duration of the animation, the default value is 0.9
    @IBInspectable public var animationDuration: CGFloat = 0.9 {
        didSet {
            stopAnimation()
            startAnimation()
        }
    }
    
    /// The bounds rectangle, which describes the view’s location and size in its own coordinate system.
    public override var bounds: CGRect {
        didSet {
            // the sublyers are based in the view size, so if the view change the size, we should redraw sublyers
            redrawDisks()
            redrawCircles()
        }
    }
    // MARK: init methods
    
    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    ///
    /// - Parameter frame: The frame rectangle for the view, measured in points.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    /// Initializes and returns a newly allocated view object from data in a given unarchiver.
    ///
    /// - Parameter aDecoder: An unarchiver object.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        
        drawSublayers()
        animateSublayers()
    }
    
    // MARK: Drawing methods
    
    /// Calculate the radius of a circle by using its index
    ///
    /// - Parameter index: the index of the circle
    /// - Returns: the radius of the circle
    func radiusOfCircle(at index: Int) -> CGFloat {
        return (circlesPadding * CGFloat(index)) + minimumCircleRadius
    }
    
    /// Lays out subviews.
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        diskLayer.position = bounds.center
        centerAnimatedLayer.position = bounds.center
        circlesLayer.forEach {
            $0.position = bounds.center
        }
    }
    
    /// Draws disks and circles
    private func drawSublayers() {
       drawDisks()
       redrawCircles()
    }
    
    /// Draw central disk and the disk for the central animation
    private func drawDisks() {
        diskLayer = Drawer.diskLayer(radius: diskRadius, origin: bounds.center, color: diskColor.cgColor)
        layer.insertSublayer(diskLayer, at: 0)
        
        centerAnimatedLayer = Drawer.diskLayer(radius: diskRadius, origin: bounds.center, color: diskColor.cgColor)
        centerAnimatedLayer.opacity = 0.3
        layer.addSublayer(centerAnimatedLayer)
    }
    
    /// Redraws disks by deleting the old ones and drawing a new ones, called for example when the radius changed
    private func redrawDisks() {
        diskLayer.removeFromSuperlayer()
        centerAnimatedLayer.removeFromSuperlayer()
        
        drawDisks()
    }

    /// Redraws circles by deleting old ones and drawing new ones, this method is called, for example, when the number of circles changed
     func redrawCircles() {
        circlesLayer.forEach {
            $0.removeFromSuperlayer()
        }
        circlesLayer.removeAll()
        for i in 0 ..< numberOfCircles {
            drawCircle(with: i)
        }
    }
    
    /// Draws the circle by using the index to calculate the radius
    ///
    /// - Parameter index: the index of the circle
    private func drawCircle(with index: Int) {
        let radius = radiusOfCircle(at: index)
        if radius > maxCircleRadius { return }
        
        let circleLayer = Drawer.circleLayer(radius: radius, origin: bounds.center, color: circleOffColor.cgColor)
        circleLayer.lineWidth = 2.0
        circlesLayer.append(circleLayer)
        self.layer.addSublayer(circleLayer)
    }
    
    // MARK: Animation methods
    
    /// Add animation to central disk and the surrounding circles 
    private func animateSublayers() {
        animateCentralDisk()
        animateCircles()
        
        startAnimation()
    }
    
    /// Animates the central disk by changing the opacitiy and the scale
    @objc private func animateCentralDisk() {
        let maxScale = maxCircleRadius / diskRadius
        let scaleAnimation = Animation.transform(to: maxScale)
        let alphaAnimation = Animation.opacity(from: 0.3, to: 0.0)
        let groupAnimation = Animation.group(animations: scaleAnimation, alphaAnimation, duration: centerAnimationDuration)
        centerAnimatedLayer.add(groupAnimation, forKey: nil)
        self.layer.addSublayer(centerAnimatedLayer)
    }
    
    /// Animates circles by changing color from off to on color
    @objc private func animateCircles() {
        for index in 0 ..< circlesLayer.count {
            let colorAnimation = Animation.color(from: circleOffColor.cgColor, to: circleOnColor.cgColor)
            colorAnimation.duration = circleAnimationDuration
            colorAnimation.autoreverses = true
            colorAnimation.beginTime = CACurrentMediaTime() + CFTimeInterval(circleAnimationDuration * Double(index))
            circlesLayer[index].add(colorAnimation, forKey: "strokeColor")
        }
    }
}

// MARK: Public methods
extension RippleView {
    
    /// Start the ripple animation
    public func startAnimation() {
        layer.removeAllAnimations()
        circlesAnimationTimer?.invalidate()
        diskAnimationTimer?.invalidate()
        let timeInterval = CFTimeInterval(animationDuration) + circleAnimationDuration
        circlesAnimationTimer =  Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(animateCircles), userInfo: nil, repeats: true)
        diskAnimationTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(animateCentralDisk), userInfo: nil, repeats: true)
    }
    
    /// Stop the ripple animation
    public func stopAnimation() {
        layer.removeAllAnimations()
        circlesAnimationTimer?.invalidate()
        diskAnimationTimer?.invalidate()
    }
}
