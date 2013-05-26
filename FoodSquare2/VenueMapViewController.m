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

-(void)setLocation:(CLLocation *)location
{
////    __mapView.centerCoordinate = location;
//    
//    MKCoordinateSpan span;
//    span.latitudeDelta=0.2;
//    span.longitudeDelta=0.2;
//    
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(location.la, <#CLLocationDegrees longitude#>)
//    
//    MKCoordinateRegion region;
//    region.span=span;
//    region.center=location;
//    
//    [mapView setRegion:region animated:TRUE];
//    [mapView regionThatFits:region];
//    
//    [self addPinToLocation:location];
}

- (void)setVenues:(NSArray *)venues
{
    
}

@end
