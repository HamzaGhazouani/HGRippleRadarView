//
//  Animal.swift
//  HGRippleRadarView_Example
//
//  Created by Hamza Ghazouani on 05/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

struct Animal {

    let title: String
    let color: UIColor
    let imageName: String

    init(title: String, color: UIColor, imageName: String) {
        self.title = title
        self.color = color
        self.imageName = imageName
    }
}
