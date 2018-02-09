//
//  RadarView.swift
//  HGNearbyUsers_Example
//
//  Created by Hamza Ghazouani on 25/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit


/// A radar view with ripple animation
@IBDesignable
final public class RadarView: RippleView {
    
    // MARK: public properties
    
    /// the maximum number of items that can be shown in the radar view, if you use more, some layers will overlaying other layers
    public var radarCapacity: Int {
        if allPossiblePositions.isEmpty {
            findPossiblePositions()
        }
        return allPossiblePositions.count
    }
    
    /// The padding between items, the default value is 10
    @IBInspectable public var paddingBetweenItems: CGFloat = 10 {
        didSet {
            redrawItems()
        }
    }
    
    /// the background color of items, by default is turquoise
    @IBInspectable public var itemBackgroundColor = UIColor.turquoise
    
    /// The bounds rectangle, which describes the view’s location and size in its own coordinate system.
    public override var bounds: CGRect {
        didSet {
            // the sublyers are based in the view size, so if the view change the size, we should redraw sublyers
            let viewRadius = min(bounds.midX, bounds.midY)
            minimumCircleRadius = viewRadius > 120 ? 60 : diskRadius + 15
            redrawItems()
        }
    }
    
    /// The frame rectangle, which describes the view’s location and size in its superview’s coordinate system.
    public override var frame: CGRect {
        didSet {
            // the sublyers are based in the view size, so if the view change the size, we should redraw sublyers
            let viewRadius = min(bounds.midX, bounds.midY)
            minimumCircleRadius = viewRadius > 120 ? 60 : diskRadius + 15
            redrawItems()
        }
    }
    
    /// The delegate of the radar view
    public weak var delegate: RadarViewDelegate?
    
    /// The data source of the radar view
    public weak var dataSource: RadarViewDataSource?
    
    /// The current selected item
    public var selectedItem: Item? {
        return currentItemView?.item
    }
    
    // MARK: private properties
    
    /// All possible positions to draw item in the radar view, you can have more positions if you have more circles
    private var allPossiblePositions = [CGPoint]()
    
    /// All available position to draw items
    private var availablePositions = [CGPoint]()
    
    /// items drawn in the radar view
    private var itemsViews = [ItemView]()
    
    /// layer to remove after hidden animation
    private var viewToRemove: UIView?
    
    /// the preferable radius of an item
    private var itemRadius: CGFloat {
        return paddingBetweenCircles / 3
    }
    
    private var currentItemView: ItemView? {
        didSet {
            if oldValue != nil && currentItemView != nil {
                delegate?.radarView(radarView: self, didDeselect: oldValue!.item)
            }
            else if oldValue != nil && currentItemView == nil {
                delegate?.radarView(radarView: self, didDeselectAllItems: oldValue!.item)
            }
            if currentItemView != nil {
                delegate?.radarView(radarView: self, didSelect: currentItemView!.item)
            }
        }
    }
    
    
    // MARK: View Life Cycle
    
    override func setup() {
        paddingBetweenCircles = 40
        let viewRadius = min(bounds.midX, bounds.midY)
        minimumCircleRadius = viewRadius > 120 ? 60 : diskRadius + 15
        
        super.setup()
    }
    
    override func redrawCircles() {
        super.redrawCircles()
        
        redrawItems()
    }
    
    private func redrawItems() {
        // remove all items and redraw them in the right positions
        let items = itemsViews
        allPossiblePositions.removeAll()
        availablePositions.removeAll()
        itemsViews.removeAll()
        
        findPossiblePositions()
        availablePositions = allPossiblePositions
        
        items.forEach {
            let view = $0.view
            view.layer.removeAllAnimations()
            view.removeFromSuperview()
            var index = $0.index
            add(item: $0.item, at: &index, using: nil)
        }
    }
    
    // MARK: Utilities methods
    
    /// browse circles and find possible position to draw layer
    private func findPossiblePositions() {
        for (index, layer) in circlesLayer.enumerated() {
            let origin = layer.position
            let radius = radiusOfCircle(at: index)
            let circle = Circle(origin: origin, radius:radius)
            
            // we calculate the capacity using: (2π * r1 / 2 * r2) ; r2 = (itemRadius + padding/2)
            let capicity = (radius * CGFloat.pi) / (itemRadius + paddingBetweenItems/2)
            
            /*
             Random Angle is used  to don't have the gap in the same place, we should find a better solution
             for example, dispatch the gap as padding between items
             let randomAngle = CGFloat(arc4random_uniform(UInt32(Float.pi * 2)))
             */
            for index in 0 ..< Int(capicity) {
                let angle = ((CGFloat(index) * 2 * CGFloat.pi) / CGFloat(capicity))/* + randomAngle */
                let itemOrigin = Geometry.point(in: angle, of: circle)
                allPossiblePositions.append(itemOrigin)
            }
        }
    }
    
    /// Add item layer to radar view
    ///
    /// - Parameters:
    ///   - item: item to add to the radar view
    ///   - index: the index of the item layer (position)
    ///   - animation: the animation used to show the item layer
    private func add(item: Item, at index: inout Int, using animation: CAAnimation? = Animation.transform()) {
        
        if allPossiblePositions.isEmpty {
            findPossiblePositions()
        }
        if availablePositions.count == 0 {
            print("HGRipplerRadarView Warning: you use more than the capacity of the radar view, some layers will overlaying other layers")
            availablePositions = allPossiblePositions
        }
        
        // try to draw the item in a precise position, if it's not possible, a random index is used
        if index >= availablePositions.count {
            index = Int(arc4random_uniform(UInt32(availablePositions.count)))
        }
        let origin = availablePositions[index]
        availablePositions.remove(at: index)
        
        let preferredSize = CGSize(width: itemRadius*2, height: itemRadius*2)
        let customView = dataSource?.radarView(radarView: self, viewFor: item, preferredSize: preferredSize)
        let itemView = addItem(view: customView, with: origin, and: animation)
        let itemLayer = ItemView(view: itemView, item: item, index: index)
        self.addSubview(itemView)
        itemsViews.append(itemLayer)
    }
    
    private func addItem(view: UIView?, with origin: CGPoint, and animation: CAAnimation?) -> UIView {
        let itemView = view ?? Drawer.diskView(radius: itemRadius, origin: origin, color: itemBackgroundColor)
        itemView.center = origin
        itemView.isUserInteractionEnabled = false
        
        guard let anim = animation else { return itemView }
        let hide = Animation.transform(to: 0.0)
        hide.duration = anim.beginTime - CACurrentMediaTime()
        itemView.layer.add(hide, forKey: nil)
        itemView.layer.add(anim, forKey: nil)
        
        return itemView
    }
    
    /// Remove layer from radar view
    ///
    /// - Parameter layer: the layer to remove
    private func removeWithAnimation(view: UIView) {
        viewToRemove = view
        let hideAnimation = Animation.hide()
        hideAnimation.delegate = self
        
        view.layer.add(hideAnimation, forKey: nil)
    }
    
    // MARK: manage user interaction
    
    /// Tells this object that one or more new touches occurred in a view or window.
    ///
    /// - Parameters:
    ///   - touches: A set of UITouch instances that represent the touches for the starting phase of the event
    ///   - event: The event to which the touches belong.
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let point = touch?.location(in: self) else { return }
        guard let index = itemsViews.index(where: {
            return $0.view.frame.contains(point)
        }) else {
            currentItemView = nil
            return
        }
        
        let item = itemsViews[index]
        if item === currentItemView { return }
        currentItemView = item
        
        let itemView = item.view
        self.bringSubview(toFront: itemView)
        let animation = Animation.opacity(from: 0.3, to: 1.0)
        itemView.layer.add(animation, forKey: "opacity")
    }
}

extension RadarView: CAAnimationDelegate {
    
    /// Tells the delegate the animation has ended.
    ///
    /// - Parameters:
    ///   - anim: The CAAnimation object that has ended.
    ///   - flag: A flag indicating whether the animation has completed by reaching the end of its duration.
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        viewToRemove?.removeFromSuperview()
        viewToRemove = nil
    }
}

// MARK: public methods
extension RadarView {
    /// Add a list of items to the radar view
    ///
    /// - Parameters:
    ///   - items: the items to add to the radar view
    ///   - animation: the animation used to show  items layers
    public func add(items: [Item], using animation: CAAnimation = Animation.transform()) {
        for index in 0 ..< items.count {
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(animation.duration/2 * Double(index))
            self.add(item: items[index], using: animation)
        }
    }
    
    /// Add item randomly in the radar view
    ///
    /// - Parameters:
    ///   - item: the item to add to the radar view
    ///   - animation: the animation used to show  items layers
    public func add(item: Item, using animation: CAAnimation = Animation.transform()) {
        if allPossiblePositions.isEmpty {
            findPossiblePositions()
        }
        
        let count = availablePositions.count == 0 ? allPossiblePositions.count : availablePositions.count
        var randomIndex = Int(arc4random_uniform(UInt32(count)))
        add(item: item, at: &randomIndex, using: animation)
    }
    
    /// Remove item layer from the radar view
    ///
    /// - Parameter item: the item to remove from Radar View
    public func remove(item: Item) {
        guard let index = itemsViews.index(where: { $0.item.uniqueKey == item.uniqueKey }) else {
            print("\(String(describing: item.uniqueKey)) not found")
            return
        }
        let item = itemsViews[index]
        removeWithAnimation(view: item.view)
        itemsViews.remove(at: index)
    }
    
    /// Returns the view of the item
    ///
    /// - Parameter item: the item
    /// - Returns: the layer of the item with the index
    public func view(for item: Item) -> UIView? {
        guard let index = itemsViews.index(where: { $0.item === item }) else { return nil }
        return itemsViews[index].view
    }
}

extension Drawer {
    /// Creates a disk layer
    ///
    /// - Parameters:
    ///   - radius: the radius of the disk
    ///   - origin: the origin of the disk
    ///   - color: the color of the disk
    /// - Returns: a disk layer
    static func diskView(radius: CGFloat, origin: CGPoint, color: UIColor) -> UIView {
        let frame = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
        let view = UIView(frame: frame)
        view.center = origin
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
        view.backgroundColor = color
        
        return view
    }}
