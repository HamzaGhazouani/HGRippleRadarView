
//  Drawer.swift
//  HGNearbyUsers_Example
//
//  Created by Hamza Ghazouani on 24/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

struct Drawer {

    /// Creates a circular layer
    ///
    /// - Parameters:
    ///   - radius: the radius of the circle
    ///   - origin: the origin of the circle
    /// - Returns: a circular layer
    private static func layer(radius: CGFloat, origin: CGPoint) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
        layer.position = origin
        
        let center = CGPoint(x: radius, y: radius)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        layer.path = path.cgPath
        
        return layer
    }
    
    /// Creates a disk layer
    ///
    /// - Parameters:
    ///   - radius: the radius of the disk
    ///   - origin: the origin of the disk
    ///   - color: the color of the disk
    /// - Returns: a disk layer
    static func diskLayer(radius: CGFloat, origin: CGPoint, color: CGColor) -> CAShapeLayer {
        let diskLayer = self.layer(radius: radius, origin: origin)
        diskLayer.fillColor = color

        return diskLayer
    }
    
    /// Creates a circle layer
    ///
    /// - Parameters:
    ///   - radius: the radius of the circle
    ///   - origin: the origin of the circle
    ///   - color: the color of the circle
    /// - Returns: a circle layer
    static func circleLayer(radius: CGFloat, origin: CGPoint, color: CGColor) -> CAShapeLayer {
        let circleLayer = self.layer(radius: radius, origin: origin)
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = color
        circleLayer.lineWidth = 1.0
        
        return circleLayer
    }
}
