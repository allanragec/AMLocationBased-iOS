Welcome to the AMLocationBased-iOS wiki!

Installing from CocoaPods
pod 'AMLocationBased'

Can be used with Google Maps too, and iOS 5 or more.
The project will have two examples of use and the lib. The lib consists of only one class, UtilsTrigonometry, in them you will find several methods that can help in other tasks, among which the main ones are:

Method that tells how many degrees the other location is me, this way you can present another location in some way, maybe using a compass. It can be used to make augmented reality.

In the example, the starting point is always the red pin.

![](http://i60.tinypic.com/or8dh0.jpg)

**+(double)getDegreesOfAnotherLocationWithMyLocation:(CLLocation *)myLocation andAnotherLocation:(CLLocation *)anotherLocation;**

![](http://i58.tinypic.com/jjo60w.jpg) ![](http://oi60.tinypic.com/2hx7z38.jpg)

Creates a second location, from an existing, from the degree informed and the desired distance.

![](http://i57.tinypic.com/10zd2m1.jpg)

**+(CLLocation*)locationFromDistance:(double)distance andDegrees:(int)degrees withMyLocation:(CLLocation*)myLocation;**

![](http://i62.tinypic.com/332royo.jpg) ![](http://i60.tinypic.com/55pl53.jpg)
