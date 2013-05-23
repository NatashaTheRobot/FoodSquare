//
//  VenueMapViewController.m
//  FoodSquare2
//
//  Created by Natasha Murashev on 5/23/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "VenueMapViewController.h"

@interface VenueMapViewController ()
{
    __weak IBOutlet MKMapView *__mapView;
}
@end

@implementation VenueMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // zoom in on user location!
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setVenues:(NSArray *)venues
{
    
}

@end
