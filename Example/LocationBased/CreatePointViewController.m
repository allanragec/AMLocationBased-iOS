//
//  CreatePointViewController.m
//  LocationBased
//
//  Created by Allan Melo on 8/29/15.
//  Copyright (c) 2015 Allan Melo. All rights reserved.
//

#import "CreatePointViewController.h"
#import <MapKit/MapKit.h>
#import "AMMapUtilsTrigonometry.h"
@interface CreatePointViewController () <UIPickerViewDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIPickerView *pckDegrees;
@property (weak, nonatomic) IBOutlet UIPickerView *pckMeters;
@property (strong, nonatomic)CLLocation *marcoZero;
@property (strong, nonatomic) NSMutableArray *valuesDegrees;
@property (strong, nonatomic) NSMutableArray *valuesMeters;
@property (strong, nonatomic) MKPointAnnotation *setMapPoint;
@end

@implementation CreatePointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Create Point Arround Marco Zero";
    self.marcoZero = [[CLLocation alloc] initWithLatitude:-8.063161 longitude:-34.871138];
    
    MKCoordinateRegion coordinate = MKCoordinateRegionMakeWithDistance(self.marcoZero.coordinate, 50, 50);
    [self.mapView setRegion:coordinate animated:YES];
    
    [self initArrays];
    self.pckDegrees.delegate = self;
    self.pckMeters.delegate = self;
    [self.pckDegrees reloadAllComponents];
    [self.pckMeters reloadAllComponents];
    
    // add marco zero point
    
    MKPointAnnotation *mapPointMarcoZero = [[MKPointAnnotation alloc] init];
    
    mapPointMarcoZero.title = @"Marco Zero, Recife-PE";
    [self.mapView addAnnotation:mapPointMarcoZero];
    mapPointMarcoZero.coordinate = self.marcoZero.coordinate;
    
    self.mapView.delegate = self;
}

-(void)initArrays{
    self.valuesDegrees = [[NSMutableArray alloc] init];
    self.valuesMeters = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 360; i++) {
        [self.valuesDegrees addObject:[[NSNumber alloc] initWithInt:i]];
            [self.valuesMeters addObject:[[NSNumber alloc] initWithInt:i]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.pckDegrees]) {
        return [self.valuesDegrees count];
    }
    return [self.valuesMeters count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.pckDegrees]) {
        return [[self.valuesDegrees objectAtIndex:row] stringValue];
    }
    return [[self.valuesMeters objectAtIndex:row] stringValue];
}


-(void)setPoint{
    if (!self.setMapPoint) {
        self.setMapPoint = [[MKPointAnnotation alloc] init];
        self.setMapPoint.title = @"Point Set";
        [self.mapView addAnnotation:self.setMapPoint];
    }
    NSInteger selectedIndexDegrees = [self.pckDegrees selectedRowInComponent:0];
    NSInteger selectedIndexMeters = [self.pckMeters selectedRowInComponent:0];
    NSNumber *degreesSelected = [self.valuesDegrees objectAtIndex:selectedIndexDegrees];
    NSNumber *metersSelected = [self.valuesMeters objectAtIndex:selectedIndexMeters];
    
    NSLog(@"Degrees %@, Meters %@", degreesSelected, metersSelected);
    
    self.setMapPoint.coordinate = [AMMapUtilsTrigonometry locationFromDistance:[metersSelected doubleValue] andDegrees:[degreesSelected intValue] withMyLocation:self.marcoZero].coordinate;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self setPoint];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isEqual:self.setMapPoint]) {
        if ([annotation isKindOfClass:[MKUserLocation class]]) {
            return nil;
        }
        MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"custom"];
        pinView.pinColor = MKPinAnnotationColorPurple;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
        
        return pinView;
    }
    return nil;
}


@end
