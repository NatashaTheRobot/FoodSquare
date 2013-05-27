//
//  VenueMapViewController.h
//  FoodSquare2
//
//  Created by Natasha Murashev on 5/23/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class Venue;

@interface VenueMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) NSArray *venues;

@property (strong, nonatomic) CLLocation *location;


- (void)resetAnnotationAtIndex:(NSInteger)index forVenue:(Venue *)venue;

@end
