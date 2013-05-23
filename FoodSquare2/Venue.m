//
//  Venue.m
//  FoodSquare2
//
//  Created by Natasha Murashev on 5/22/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "Venue.h"

@implementation Venue

- (id)init
{
    self = [super init];
    
    if (self) {
        self.image = [UIImage imageNamed:@"foursquare-logo.jpg"];
    }
    
    return self;
}

@end
