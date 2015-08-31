//
//  UtilsTrigonometry.m
//
//      NV            = Is the true north, the compass returns values in degrees from it
//      α             = Alpha is the internal angle of the triangle that represented by me
//      O             = The point is that we observe
//      DLA           = latitude difference to have the value of one of the cathetus
//      DLO           = longitude difference to have the value of one of the cathetus
//      HIP           = Hypotenuse, which is equal to the distance between points
//      True Course   = Is the angle relative to true north can vary with each quadrant to observe the desired point
//      MIN TOLERENCE = 10 meters
//      P1            = if the variation of the longitude is less than the tolerance of minimum and latitude is greater than the point O
//      P2            = if the variation of the latitude is less than the tolerance of minimum and longitude is greater than the point O
//      P3            = if the variation of the longitude is less than the tolerance of minimum and latitude is less than the point O
//      P4            = if the variation of the latitude is less than the tolerance of minimum and longitude is less than the point O
//
//      1º QUADRANT    2º QUADRANT
//             True Course
//                  P1
//     ( 180º - α ) | ( 180º + α )
//          NV      |       NV
//          |0º     |       |0º
//          |       |       |
//          |\      |      /|
//         D|α\ H   |    H/α|D
//         L|  \ I  |   I/  |L
//         A|   \ P |  P/   |A
//          |    \  |  /    |
//          ‾‾‾‾‾‾  |  ‾‾‾‾‾‾
//            DLO   |    DLO
//   P4 ------------O------------- P2
//                  |
//              H/| |  |\H
//         NV  I/ |D| D| \I  NV
//        0º| P/  |L| L|  \P |0º
//          | /   |A| A|   \ |
//          |/α   | |  |   α\|
//           ‾‾‾‾‾  |   ‾‾‾‾‾
//            DLO   |    DLO
//     ( 90º  - α ) |  ( 270º + α )
//                  P3
//             True Course
//     3º QUADRANT     4º QUADRANT
//
//  Created by Allan Melo on 1/12/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "AMMapUtilsTrigonometry.h"

#define DEGREES_0 0
#define DEGREES_90 90
#define DEGREES_180 180
#define DEGREES_270 270
#define DEGREES_360 360

@implementation AMMapUtilsTrigonometry

+(double)getHypotenuseWithPointA:(CLLocation *)pointA andPointB:(CLLocation *)pointB{
    // only returns the distance of latitude
    return [pointA distanceFromLocation:pointB];
}

+(double)getLatitudeDistanceWithPointA:(CLLocation *)pointA andPointB:(CLLocation *)pointB{
    // only returns the distance of latitude
    CLLocation *temp = [[CLLocation alloc] initWithLatitude: pointB.coordinate.latitude  longitude:pointA.coordinate.longitude];
    return [pointA distanceFromLocation:temp];
}

+(double)getLongitudeDistanceWithPointA:(CLLocation *)pointA andPointB:(CLLocation *)pointB{
    // only returns the distance of longitude
    CLLocation *temp = [[CLLocation alloc] initWithLatitude: pointA.coordinate.latitude  longitude:pointB.coordinate.longitude];
    return [pointA distanceFromLocation:temp];
}

+(double)getTangentWithCathetusOpposite:(double)cathetusOpposite andCathetusAdjacent:(double)cathetusAdjacent{
    // considering α, tangent of an angle is equal to the opposite side of the adjacent
    return cathetusOpposite / cathetusAdjacent;
}

+(double)getSineWithCathetusOpposite:(double)cathetusOpposite andHypotenuse:(double)hypotenuse{
    //considering α, sine of an angle is equal to the opposite side over the hypotenuse
    return cathetusOpposite / hypotenuse;
}

+(double)getCosineWithHypotenuse:(double)hypotenuse andCathetusAdjacent:(double)cathetusAdjacent{
    // considering α, cosine of an angle is equal to the hypotenuse of the adjacent cathetus
    return hypotenuse / cathetusAdjacent;
}

+(double)getInverseTangentRadians:(double)value{
    // returns the inverse tangent
    return atan(value);
}

+(double)getThirdAngleOfTriangleRectangle:(double) angle{
    // returns the third angle of the triangle
    return DEGREES_180 - DEGREES_90 - angle;
}

+(double)convertRadiansToDegrees:(double)value{
    // convert Radians to degrees
    return (value * 180) / M_PI;
}

+(double)convertDegreesToRadians:(double)value{
    // convert degrees to Radians
    return (value * M_PI) / 180;
}

+(double)getDegreesOfAnotherLocationWithMyLocation:(CLLocation *)myLocation andAnotherLocation:(CLLocation *)anotherLocation{
    // min distance tolerance in meters
    const int MIN_DISTANCE = 1;
    // latitude difference to have the value of one of the cathetus
    const double DLA = [self getLatitudeDistanceWithPointA:myLocation andPointB:anotherLocation];
    // longitude difference to have the value of one of the cathetus
    const double DLO = [self getLongitudeDistanceWithPointA:myLocation andPointB:anotherLocation];
    
    const double myLatitudeInRelationToAnother = myLocation.coordinate.latitude - anotherLocation.coordinate.latitude;
    
    const double myLongitudeInRelationToAnother = myLocation.coordinate.longitude - anotherLocation.coordinate.longitude;
    
    
    if([myLocation distanceFromLocation:anotherLocation] <= MIN_DISTANCE){
        //displays centralized (any degree)
        return -1;
    }else if (DLO < MIN_DISTANCE && myLatitudeInRelationToAnother > 0){
        // 180º (165º ~ 195º)
        return 180;
    }else if (DLA < MIN_DISTANCE && myLongitudeInRelationToAnother > 0){
        // 270º (255º ~ 285º)
        return 270;
    }else if (DLO < MIN_DISTANCE && myLatitudeInRelationToAnother < 0){
        // 0º   (345º ~ 15º)
        return 0;
    }else if (DLA < MIN_DISTANCE && myLongitudeInRelationToAnother < 0){
        // 90º  (85º ~ 105º)
        return 90;
    }else if (myLatitudeInRelationToAnother > 0 && myLongitudeInRelationToAnother < 0){
        //  1º QUADRANT ( 180º - α ) = Result +- 15º / α = graus(arcTang(Tang(DLO/DLA)))
        const double tangent = [self getTangentWithCathetusOpposite:DLO andCathetusAdjacent:DLA];
        const double inverseTangent = [self getInverseTangentRadians:tangent];
        const double alpha = [self convertRadiansToDegrees:inverseTangent];
        const double trueCourse = 180 - alpha;
        return trueCourse;
    }else if (myLatitudeInRelationToAnother > 0 && myLongitudeInRelationToAnother > 0){
        //  2º QUADRANT ( 180º + α ) = Result +- 15º / α = graus(arcTang(Tang(DLO/DLA)))
        const double tangent = [self getTangentWithCathetusOpposite:DLO andCathetusAdjacent:DLA];
        const double inverseTangent = [self getInverseTangentRadians:tangent];
        const double alpha = [self convertRadiansToDegrees:inverseTangent];
        const double trueCourse = 180 + alpha;
        return trueCourse;
    }else if (myLatitudeInRelationToAnother < 0 && myLongitudeInRelationToAnother < 0){
        // 3º QUADRANT ( 90º  - α ) = Result +- 15º / α = graus(arcTang(Tang(DLA/DLO)))
        const double tangent = [self getTangentWithCathetusOpposite:DLA andCathetusAdjacent:DLO];
        const double inverseTangent = [self getInverseTangentRadians:tangent];
        const double alpha = [self convertRadiansToDegrees:inverseTangent];
        const double trueCourse = 90 - alpha;
        return trueCourse;
    }else if (myLatitudeInRelationToAnother < 0 && myLongitudeInRelationToAnother > 0){
        // 4º QUADRANT ( 270º + α ) = Result +- 15º / α = graus(arcTang(Tang(DLA/DLO)))
        const double tangent = [self getTangentWithCathetusOpposite:DLA andCathetusAdjacent:DLO];
        const double inverseTangent = [self getInverseTangentRadians:tangent];
        const double alpha = [self convertRadiansToDegrees:inverseTangent];
        const double trueCourse = 270 + alpha;
        return trueCourse;
    }
    return 0;
}


//      1º QUADRANT    2º QUADRANT
//             True Course
//                 LATITUDE
//                    P1
// >= 271º && <= 359º |  >= 1º && <= 89º
//            NV      |   NV
//            |0º     |   |0º
//            |       |   | DLO
//            |\      |   |‾‾‾‾‾/
//           D| \ H   |  D|    /H
//           L|  \ I  |  L|   /I
//           A|   \ P |  A|  /P
//            |   α\  |   |α/
//            ‾‾‾‾‾‾  |   |/
//              DLO   |    DLO
//     P4 ------------O------------- P2  LONGITUDE
//                    |NV0º| DLO
//                    |    |______
//                H/| |     \α   |
//           NV  I/α|D|    H \   |D
//          0º| P/  |L|     I \  |L
//            | /   |A|      P \ |A
//            |/    | |         \|
//             ‾‾‾‾‾  |
//              DLO   |
// >= 181º && <= 269º |  >= 91º && <= 179º
//                    P3
//               True Course
//       3º QUADRANT     4º QUADRANT
+(CLLocation*)locationFromDistance:(double)distance andDegrees:(int)degrees withMyLocation:(CLLocation*)myLocation{
    double latitude = myLocation.coordinate.latitude;
    double longitude = myLocation.coordinate.longitude;
    
    if (degrees == DEGREES_0 || degrees == DEGREES_360) {
        return [[CLLocation alloc] initWithLatitude:latitude + [self distanceInMetersForLatitude:distance]
                                          longitude:longitude];
    }else if (degrees == DEGREES_90){
        return [[CLLocation alloc] initWithLatitude:latitude
                                          longitude:longitude + [self distanceInMetersForLongitude:distance]];
    }else if (degrees == DEGREES_180){
        return [[CLLocation alloc] initWithLatitude:latitude - [self distanceInMetersForLatitude:distance]
                                          longitude:longitude];
    }else if (degrees == DEGREES_270){
        return [[CLLocation alloc] initWithLatitude:latitude
                                          longitude:longitude - [self distanceInMetersForLongitude:distance]];
    }else{
        double sumDegreesTriangleRectangle = 180;
        double rightAngle = 90;
        double a = rightAngle;
        if (degrees >= 1 && degrees <= 89){  //P1
            double b = degrees;
            double c = sumDegreesTriangleRectangle - (a + b);
            double hypotenuse = distance;
            // Pythagorean theorem
            // Sin(α) = cathetus Adjacent/hipotenuse
            double cathetusOpposite = sin([self convertDegreesToRadians:b]) * hypotenuse;
            //  hypotenuse = cathetus Opposite/cathetus Adjacent
            double cathetusAdjacent = sin([self convertDegreesToRadians:c]) * hypotenuse;
            // + latitude = cathetusAdjacent
            // + longitude = cathetusOpposite
            return [[CLLocation alloc] initWithLatitude:latitude + [self distanceInMetersForLatitude:cathetusAdjacent]
                                              longitude:longitude + [self distanceInMetersForLongitude:cathetusOpposite]];
        }else if (degrees >= 91 && degrees <= 179){ //P2
            // for normalize
            degrees -= DEGREES_90;
            double b = degrees;
            double c = sumDegreesTriangleRectangle - (a + b);
            double hypotenuse = distance;
            double cathetusOpposite = sin([self convertDegreesToRadians:b]) * hypotenuse;
            double cathetusAdjacent = sin([self convertDegreesToRadians:c]) * hypotenuse;
            // - latitude = cathetusOpposite
            // + longitude = cathetusAdjacent
            return [[CLLocation alloc] initWithLatitude:latitude - [self distanceInMetersForLatitude:cathetusOpposite]
                                              longitude:longitude + [self distanceInMetersForLongitude:cathetusAdjacent]];
        }else if (degrees >= 181 && degrees <= 269){ //P3
            // for normalize
            degrees -= DEGREES_180;
            double b = degrees;
            double c = sumDegreesTriangleRectangle - (a + b);
            double hypotenuse = distance;
            double cathetusOpposite = sin([self convertDegreesToRadians:b]) * hypotenuse;
            double cathetusAdjacent = sin([self convertDegreesToRadians:c]) * hypotenuse;
            // - latitude = cathetusAdjacent
            // - longitude = cathetusOpposite
            return [[CLLocation alloc] initWithLatitude:latitude - [self distanceInMetersForLatitude:cathetusAdjacent]
                                              longitude:longitude - [self distanceInMetersForLongitude:cathetusOpposite]];
        }else if (degrees >= 271 && degrees <= 359){ //P4
            // for normalize
            degrees -= DEGREES_270;
            double b = degrees;
            double c = sumDegreesTriangleRectangle - (a + b);
            double hypotenuse = distance;
            double cathetusOpposite = sin([self convertDegreesToRadians:b]) * hypotenuse;
            double cathetusAdjacent = sin([self convertDegreesToRadians:c]) * hypotenuse;
            // + latitude = cathetusOpposite
            // - longitude = cathetusAdjacent
            return [[CLLocation alloc] initWithLatitude:latitude + [self distanceInMetersForLatitude:cathetusOpposite]
                                              longitude:longitude - [self distanceInMetersForLongitude:cathetusAdjacent]];
        }
        
    }
    return myLocation;
}

+(double)distanceInMetersForLatitude:(double)meters{
    // 0.0000090437      precision 1.0000005782635148 meter
    double oneMeterForLatitude = 0.0000090437;
    return oneMeterForLatitude * meters;
}

+(double)distanceInMetersForLongitude:(double)meters{
    // 0.000008983159037 precision 1.0000006897138338 meter
    double oneMeterForLongitude = 0.0000089831528500111;
    return oneMeterForLongitude * meters;
}

+(double)degreeNormalize:(double)value {
    if(value < 0) {
        value += 360;
    } else if(value > 360) {
        value -= 360;
    }
    return value;
}

@end