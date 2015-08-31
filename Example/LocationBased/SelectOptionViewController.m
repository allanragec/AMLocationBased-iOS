//
//  SelectOptionViewController.m
//  LocationBased
//
//  Created by Allan Melo on 8/29/15.
//  Copyright (c) 2015 Allan Melo. All rights reserved.
//

#import "SelectOptionViewController.h"
#import "LookForPointViewController.h"
#import "CreatePointViewController.h"

@interface SelectOptionViewController ()

@end

@implementation SelectOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goToLookForPoint:(id)sender {
    LookForPointViewController *lookForPointViewController = [[LookForPointViewController alloc] init];
    [self.navigationController pushViewController:lookForPointViewController animated:YES];
}
- (IBAction)goToCreatePoint:(id)sender {
    CreatePointViewController *createPointViewController = [[CreatePointViewController alloc] init];
    [self.navigationController pushViewController:createPointViewController animated:YES];
    
}


@end
