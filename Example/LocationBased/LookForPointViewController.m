//
//  LookForPointViewController.m
//  LocationBased
//
//  Created by Allan Melo on 8/29/15.
//  Copyright (c) 2015 Allan Melo. All rights reserved.
//

#import "LookForPointViewController.h"
#import <MapKit/MapKit.h>
#import "AMMapUtilsTrigonometry.h"
@interface LookForPointViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic)CLLocation *marcoZero;
@property (strong, nonatomic) MKPointAnnotation *meMapPoint;
@end

@implementation LookForPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"LOOK FOR MARCO ZERO, RECIFE - PE";
    self.marcoZero = [[CLLocation alloc] initWithLatitude:-8.063161 longitude:-34.871138];
//    self.mapView.zoomEnabled = NO;
    self.mapView.rotateEnabled = NO;
    
    MKCoordinateRegion coordinate = MKCoordinateRegionMakeWithDistance(self.marcoZero.coordinate, 50, 50);
    [self.mapView setRegion:coordinate animated:YES];
    
    self.mapView.delegate = self;
    
    // add marco zero point
    
    MKPointAnnotation *mapPointMarcoZero = [[MKPointAnnotation alloc] init];
    
    mapPointMarcoZero.title = @"Marco Zero, Recife-PE";
    [self.mapView addAnnotation:mapPointMarcoZero];
    mapPointMarcoZero.coordinate = self.marcoZero.coordinate;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"Latitude %lf, Longitude %lf ", mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
    
    if (!self.meMapPoint) {
        self.meMapPoint = [[MKPointAnnotation alloc] init];
        self.meMapPoint.title = @"ME";
        [self.mapView addAnnotation:self.meMapPoint];
    }
    if (CLLocationCoordinate2DIsValid(mapView.centerCoordinate)) {
        self.meMapPoint.coordinate = mapView.centerCoordinate;
        UIImage *image = [UIImage imageNamed:@"arrow20"];
        CLLocation *meLocation = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
        double degrees = [AMMapUtilsTrigonometry getDegreesOfAnotherLocationWithMyLocation:meLocation andAnotherLocation:self.marcoZero];
        [[self.mapView viewForAnnotation:self.meMapPoint] setImage:[self imageRotatedByDegrees:degrees andImage:image]];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if (self.meMapPoint) {
        static NSString *viewID = @"MKPinAnnotationView";
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:viewID];
        
        if (annotationView ==nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:viewID];
            annotationView.image = [UIImage imageNamed:@"arrow20"];
            annotationView.canShowCallout = YES;
            // for set anchor on center image
            annotationView.centerOffset = CGPointMake(-2, +3);
        }
        else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;

    }
    return nil;
}


- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees andImage:(UIImage*)image
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation([AMMapUtilsTrigonometry convertDegreesToRadians:degrees]);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, [AMMapUtilsTrigonometry convertDegreesToRadians:degrees]);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


@end
