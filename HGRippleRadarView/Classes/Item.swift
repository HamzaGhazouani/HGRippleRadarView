//
//  Item.swift
//  HGRippleRadarView
//
//  Created by Hamza Ghazouani on 27/01/2018.
//

import UIKit


/// Item object
public class Item {
    
    /// The unique key of the object
    public let uniqueKey: String
    /// The value of the object
    public let value: Any
    
    /// A new item initialized with the unique key and value
    ///
    /// - Parameters:
    ///   - uniqueKey: the key of the object, must be unique
    ///   - value: the value of the objet
    public init(uniqueKey: String, value: Any) {
        self.uniqueKey = uniqueKey
        self.value = value
    }
}
