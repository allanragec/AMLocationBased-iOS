//
//  UtilsTrigonometry.h
//
//  Created by Allan Melo on 1/12/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AMMapUtilsTrigonometry : NSObject

+(double)getHypotenuseWithPointA:(CLLocation *)pointA andPointB:(CLLocation *)pointB;

+(double)getLatitudeDistanceWithPointA:(CLLocation *)pointA andPointB:(CLLocation *)pointB;

+(double)getLongitudeDistanceWithPointA:(CLLocation *)pointA andPointB:(CLLocation *)pointB;

+(double)getTangentWithCathetusOpposite:(double)cathetusOpposite andCathetusAdjacent:(double)cathetusAdjacent;

+(double)getSineWithCathetusOpposite:(double)cathetusOpposite andHypotenuse:(double)hypotenuse;

+(double)getCosineWithHypotenuse:(double)hypotenuse andCathetusAdjacent:(double)cathetusAdjacent;

+(double)getInverseTangentRadians:(double)value;

+(double)getThirdAngleOfTriangleRectangle:(double) angle;

+(double)convertRadiansToDegrees:(double)value;

+(double)convertDegreesToRadians:(double)value;

+(double)getDegreesOfAnotherLocationWithMyLocation:(CLLocation *)myLocation andAnotherLocation:(CLLocation *)anotherLocation;

+(CLLocation*)locationFromDistance:(double)distance andDegrees:(int)degrees withMyLocation:(CLLocation*)myLocation;

+(double)distanceInMetersForLatitude:(double)meters;

+(double)distanceInMetersForLongitude:(double)meters;

+(double)degreeNormalize:(double)value;

@end
