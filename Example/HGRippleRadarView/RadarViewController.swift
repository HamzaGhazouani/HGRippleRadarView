//
//  RadarViewController.swift
//  HGRippleRadarView_Example
//
//  Created by Hamza Ghazouani on 28/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import HGRippleRadarView

class RadarViewController: UIViewController {

    var timer: Timer?
    var index = 0
    var items = [Item]()
    
    var radarView: RadarView? {
        return view as? RadarView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        radarView?.delegate = self
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(addItem), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func addItem() {
        if index > 3 {
            addMultipleItems()
            timer?.invalidate()
            return
        }
        let item = Item(uniqueKey: "item\(index)", value:"item\(index)")
        items.append(item)
        radarView?.add(item: item)
        index += 1
    }
    
    func addMultipleItems() {
        var tempItems = [Item]()
        for _ in 0 ..< 3 {
            let item = Item(uniqueKey: "item\(index)", value:"item\(index)")
            tempItems.append(item)
            index += 1
        }
        items.append(contentsOf: tempItems)
        radarView?.add(items: tempItems)
//        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(removeFirstItem), userInfo: nil, repeats: false)
    }
    
    @objc func removeFirstItem() {
        radarView?.remove(item: items.first!)
    }
}

extension RadarViewController: RadarViewDelegate {
    func radarView(radarView: RadarView, didSelect item: Item) {
        print(item.uniqueKey)
    }
    
    func radarView(radarView: RadarView, didDeselect item: Item) {}
    
    func radarView(radarView: RadarView, didDeselectAllItems lastSelectedItem: Item) {}
}

