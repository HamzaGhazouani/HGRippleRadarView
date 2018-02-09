//
//  RadarViewProtocol.swift
//  HGNearbyUsers_Example
//
//  Created by Hamza Ghazouani on 26/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

/// Responsible for providing the views required by a RadarView, if this protocol is not implemented the default view is used
public protocol RadarViewDataSource: class {

    /// Asks for the view of a particular item
    ///
    /// - Parameters:
    ///   - radarView: The radar view
    ///   - item: The particular item
    ///   - preferredSize: The preferred size to use
    /// - Returns: The view of the item
    func radarView(radarView: RadarView, viewFor item: Item, preferredSize: CGSize) -> UIView
    
}

/// Responsible to perform actions of the items of RadarView
public protocol RadarViewDelegate: class {
    
    /// Tells the delegate that the specified item is selected.
    ///
    /// - Parameters:
    ///   - radarView: the radar view
    ///   - item: the selected item 
    func radarView(radarView: RadarView, didSelect item: Item)
    
    /// Tells the delegate that the specified item is deselected by clicking in another one
    ///
    /// - Parameters:
    ///   - radarView: the radar view
    ///   - item: the deselected item
    func radarView(radarView: RadarView, didDeselect item: Item)
    
   
    ///
    /// - Parameter radarView: the radar view
    
    /// Tells the delegate that all items are deselected, it happens when the user click in an empty zone
    ///
    /// - Parameters:
    ///   - radarView: the radar view
    ///   - lastItem: the last selected item 
    func radarView(radarView: RadarView, didDeselectAllItems lastSelectedItem: Item)

}

