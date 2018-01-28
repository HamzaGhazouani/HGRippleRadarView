//
//  ItemLayer.swift
//  HGRippleRadarView
//
//  Created by Hamza Ghazouani on 27/01/2018.
//

import UIKit

struct ItemLayer {
    
    /// the layer of the item, stored to know if the user tap on it
    let layer: CALayer
    /// the item, stored to save the user item
    let item: Item
    /// the position of the item, stored to deraw the layer in the same place if needed (rotation for example)
    var index: Int
    
    init(layer: CALayer, item: Item, index: Int) {
        self.layer = layer
        self.item = item
        self.index = index
    }
}
