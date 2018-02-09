//
//  ItemLayer.swift
//  HGRippleRadarView
//
//  Created by Hamza Ghazouani on 27/01/2018.
//

import UIKit

class ItemView {
    /// the view of the item, stored to know if the user tap on it
    let view: UIView
    /// the item, stored to save the user item
    let item: Item
    /// the position of the item, stored to deraw the layer in the same place if needed (rotation for example)
    var index: Int
    
    init(view: UIView, item: Item, index: Int) {
        self.view = view
        self.item = item
        self.index = index
    }
}
