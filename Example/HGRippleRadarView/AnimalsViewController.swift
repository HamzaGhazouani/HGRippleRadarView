//
//  AnimalsViewController.swift
//  HGRippleRadarView_Example
//
//  Created by Hamza Ghazouani on 05/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import HGRippleRadarView

class AnimalsViewController: UIViewController {

    @IBOutlet weak var radarView: RadarView!
    @IBOutlet weak var selectedAnimalView: AnimalView!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        radarView?.dataSource = self
        radarView?.delegate = self
        
       let animals = [
            Animal(title: "Bird", color: .lightBlue, imageName: "bird"),
            Animal(title: "Cat", color: .lightGray, imageName: "cat"),
            Animal(title: "Cattle", color: .lightGray, imageName: "catttle"),
            Animal(title: "Dog", color: .darkYellow, imageName: "dog"),
            Animal(title: "Rat", color: .lightBlack, imageName: "rat")
        ]
       let items = animals.map { Item(uniqueKey: $0.title, value: $0) }
        radarView.add(items: items)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func enlarge(view: UIView?) {
        let animation = Animation.transform(from: 1.0, to: 1.5)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        view?.layer.add(animation, forKey: "transform")
    }
    
    private func reduce(view: UIView?) {
        let animation = Animation.transform(from: 1.5, to: 1.0)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        view?.layer.add(animation, forKey: "transform")
    }
    
    private func showView(for animal: Animal) {
        selectedAnimalView.tintColor = animal.color
        selectedAnimalView.titleLabel.text = animal.title
        if let image =  UIImage(named: animal.imageName) {
            selectedAnimalView.imageView.image = image
        }

        bottomLayoutConstraint.constant = 0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideAnimalView(completion: (() -> Void)? = nil) {
        bottomLayoutConstraint.constant = -250
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            completion?()
        }
    }
}

extension AnimalsViewController: RadarViewDataSource {
    
    func radarView(radarView: RadarView, viewFor item: Item, preferredSize: CGSize) -> UIView {
        let animal = item.value as? Animal
        let frame = CGRect(x: 0, y: 0, width: preferredSize.width, height: preferredSize.height)
        let imageView = UIImageView(frame: frame)
        
        guard let imageName = animal?.imageName else { return imageView }
        let image =  UIImage(named: imageName)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill

        return imageView
    }
}

extension AnimalsViewController: RadarViewDelegate {
    
    func radarView(radarView: RadarView, didSelect item: Item) {
        let view = radarView.view(for: item)
        enlarge(view: view)
        
        guard let animal = item.value as? Animal else { return }
        if bottomLayoutConstraint.constant == 0 {
            hideAnimalView {
                self.showView(for: animal)
            }
        } else {
            showView(for: animal)
        }
    }
    
    func radarView(radarView: RadarView, didDeselect item: Item) {
        let view = radarView.view(for: item)
        reduce(view: view)
    }
    
    func radarView(radarView: RadarView, didDeselectAllItems lastSelectedItem: Item) {
        let view = radarView.view(for: lastSelectedItem)
        reduce(view: view)
        hideAnimalView()
    }
}
