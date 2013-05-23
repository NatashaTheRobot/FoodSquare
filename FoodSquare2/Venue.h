//
//  Venue.h
//  FoodSquare2
//
//  Created by Natasha Murashev on 5/22/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *numberOfPeopleHereNow;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (assign, nonatomic) NSInteger zipCode;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSURL *menuURL;
@property (strong, nonatomic) NSURL *reservationURL;
@property (assign, nonatomic) NSInteger checkInCount;
@property (assign, nonatomic) NSInteger usersCount;
@property (strong, nonatomic) NSString *foursquareId;

@end
