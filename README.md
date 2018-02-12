# HGRippleRadarView

[![CI Status](http://img.shields.io/travis/HamzaGhazouani/HGRippleRadarView.svg?style=flat)](https://travis-ci.org/HamzaGhazouani/HGRippleRadarView)
[![Version](https://img.shields.io/cocoapods/v/HGRippleRadarView.svg?style=flat)](http://cocoapods.org/pods/HGRippleRadarView)
[![License](https://img.shields.io/cocoapods/l/HGRippleRadarView.svg?style=flat)](http://cocoapods.org/pods/HGRippleRadarView)
[![Language](https://img.shields.io/badge/language-Swift-orange.svg?style=flat)]()
[![Supports](https://img.shields.io/badge/supports-CocoaPods%20%7C%20Carthage-green.svg?style=flat)]()
[![Platform](https://img.shields.io/cocoapods/p/HGRippleRadarView.svg?style=flat)](http://cocoapods.org/pods/HGRippleRadarView)
<br />

[![Twitter: @GhazouaniHamza](https://img.shields.io/badge/contact-@GhazouaniHamza-blue.svg?style=flat)](https://twitter.com/GhazouaniHamza)
[![Documentation](https://img.shields.io/badge/Documentation-available-0D2D54.svg)](https://hamzaghazouani.github.io/HGRippleRadarView/)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/hamzaghazouani/hgrippleradarview)](http://clayallsopp.github.io/readme-score?url=https://github.com/hamzaghazouani/hgrippleradarview)

## Example

![](/Screenshots/radar_example_1.gif) ![](/Screenshots/radar_example_2.gif) ![](/Screenshots/ripple_example.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.
<br />
This project is inspired by: https://dribbble.com/shots/2242921-Find-Nearby-Users-Concept

## Requirements
- iOS 8.0+
- Xcode 9.2

## You also may like
* **[HGCircularSlider](https://github.com/HamzaGhazouani/HGCircularSlider)** - A custom reusable circular slider control for iOS application.
* **[HGPlaceholders](https://github.com/HamzaGhazouani/HGPlaceholders)** - Nice library to show placeholders and Empty States for any UITableView/UICollectionView in your project Edit


## Installation

HGRippleRadarView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HGRippleRadarView'
```

HGRippleRadarView is also available through [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Cartfile:


``` ruby
github "HamzaGhazouani/HGRippleRadarView"
```

## Usage

1. Change the class of a view from UIView to RippleView or RadarView
2. Programmatically:

```
let rippleView = RippleView(frame: myFrame)

```

```
let radarView = RadarView(frame: myFrame)

```

## Customization 

#### RippleView 

##### diskRadius
The radius of the central disk in the view, if you would like to hide it, you can set the radius to 0
![](/Screenshots/diskRadius.gif)

##### diskColor
The color of the central disk in the view, the default color is ripplePink color
![](/Screenshots/diskColor.gif)

##### minimumCircleRadius
This property make distance between the first circle and the central disk  
![](/Screenshots/minimumCircleRadius.gif)

##### numberOfCircles
The number of circles to draw around the disk, the default value is 3
![](/Screenshots/numberOfCircles.gif)

##### paddingBetweenCircles
The padding between circles, circles could be drawn outside the frame 
![](/Screenshots/paddingBetweenCircles.gif)

##### circleOffColor
The color of the off status of the circle, used for animation
##### circleOnColor
The color of the on status of the circle, used for animation
![](/Screenshots/OffOnColors.gif)

##### animationDuration
The duration of the animation, the default value is 0.9
![](/Screenshots/animationDuration.gif)

<br />
You can start/ stop the animation at any time by calling `startAnimation()` & `stopAnimation()`

#### RadarView 

##### paddingBetweenItems
The padding between items, the default value is 10
![](/Screenshots/paddingBetweenItems.gif)

#### Add items 
If you would like to add one item, use the method `add(item:using:)`
If you would like to add multiple items, it's recommended to use the method `add(items:using:)`

#### remove item 
If you would like to remove an item, use the method `remove(item:)`

#### Custom item 
If you would like to customize items, use the protocol `RadarViewDataSource` and implement: 


```
radarView?.dataSource = self 
...
func radarView(radarView: RadarView, viewFor item: Item, preferredSize: CGSize) -> UIView {
        let myCustomItemView = UIView(frame: CGRect(x: 0, y: 0, width: preferredSize.width, height: preferredSize.height))
        return myCustomItemView
}
```

#### CallBack
If you would like to receive action on items, use the protocol `RadarViewDelegate` and implement: 
```
radarView?.delegate = self 
...
 func radarView(radarView: RadarView, didSelect item: Item) {
        print(item.uniqueKey)
}
```


## Documentation
Full documentation is available on [CocoaDocs](http://cocoadocs.org/docsets/HGRippleRadarView/).<br/>
You can also install documentation locally using [jazzy](https://github.com/realm/jazzy).


## Author

HamzaGhazouani, hamza.ghazouani@gmail.com

## License

HGRippleRadarView is available under the MIT license. See the LICENSE file for more info.
