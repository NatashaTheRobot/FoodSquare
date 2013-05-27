//
//  VenueAnnotation.h
//  FoodSquare2
//
//  Created by Natasha Murashev on 5/26/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Venue.h"

@interface VenueAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic, strong) Venue *venue;

@end
