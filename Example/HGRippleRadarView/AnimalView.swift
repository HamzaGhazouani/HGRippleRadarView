//
//  AnimalView.swift
//  HGRippleRadarView_Example
//
//  Created by Hamza Ghazouani on 05/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class AnimalView: UIView {

    override var tintColor: UIColor! {
        didSet {
            actionButton.backgroundColor = tintColor
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!

}
