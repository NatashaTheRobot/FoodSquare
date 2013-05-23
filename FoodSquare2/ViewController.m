//
//  ViewController.m
//  FoodSquare2
//
//  Created by Natasha Murashev on 5/22/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "ViewController.h"
#import "Foursquare2.h"
#import "Venue.h"

@interface ViewController ()
{
    NSArray *_venuesSortedByCheckins;
    __weak IBOutlet UIActivityIndicatorView *_activityIndicator;
    CLLocationManager *_locationMananger;
}

- (void)getFoursquareVenuesWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude;
- (void)getImagesForVenues;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationMananger = [[CLLocationManager alloc] init];
    _locationMananger.delegate = self;
    
    _activityIndicator.hidesWhenStopped = YES;
    [_activityIndicator startAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_locationMananger startUpdatingLocation];
}

- (void)getFoursquareVenuesWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude
{
    _venuesSortedByCheckins = [NSArray array];
    
    [Foursquare2 searchVenuesNearByLatitude:[NSNumber numberWithFloat:latitude]
                                  longitude:[NSNumber numberWithFloat:longitude]
                                 accuracyLL:nil
                                   altitude:nil
                                accuracyAlt:nil
                                      query:nil
                                      limit:[NSNumber numberWithInt:50]
                                 categoryId:@"4d4b7105d754a06374d81259"
                                     intent:0
                                     radius:[NSNumber numberWithInt:800]
                                   callback:^(BOOL success, id result) {
                                       
                                       if (success) {
                                           
                                       
                                           NSMutableArray *venuesUnsorted = [NSMutableArray array];
                                       
                                           NSArray *venuesArray = [result valueForKeyPath:@"response.venues"];
                                           
                                           for (NSDictionary *venue in venuesArray) {
                                           
                                               Venue *newVenue = [[Venue alloc] init];
                                           
                                               newVenue.name = [venue objectForKey:@"name"];
                                               newVenue.numberOfPeopleHereNow = [[venue valueForKeyPath:@"hereNow.count"] intValue];
                                               newVenue.address = [venue valueForKeyPath:@"location.address"];
                                               newVenue.city = [venue valueForKeyPath:@"location.city"];
                                               newVenue.state = [venue valueForKeyPath:@"location.state"];
                                               newVenue.zipCode = [[venue valueForKeyPath:@"location.postalCode"] intValue];
                                               newVenue.latitude = [venue valueForKeyPath:@"location.lat"];
                                               newVenue.longitude = [venue valueForKeyPath:@"location.lng"];
                                               newVenue.menuURL = [NSURL URLWithString:[venue valueForKeyPath:@"menu.mobileUrl"]];
                                               newVenue.reservationURL = [NSURL URLWithString:[venue valueForKeyPath:@"reservations.url"]];
                                               newVenue.checkInCount = [[venue valueForKeyPath:@"stats.checkinsCount"] intValue];
                                               newVenue.usersCount = [[venue valueForKeyPath:@"stats.usersCount"] intValue];
                                               newVenue.foursquareId = [venue objectForKey:@"id"];
                                                                                      
                                               [venuesUnsorted addObject:newVenue];
                                           }
                                       
                                           _venuesSortedByCheckins = [venuesUnsorted sortedArrayUsingComparator:^NSComparisonResult(Venue *venue1, Venue *venue2) {
                                               NSNumber *checkinCount1 = [NSNumber numberWithInt:venue1.checkInCount];
                                               NSNumber *checkinCount2 = [NSNumber numberWithInt:venue2.checkInCount];
                                           
                                               return ([checkinCount1 compare:checkinCount2] == NSOrderedAscending);
                                           }];
                                       
                                           [self.tableView reloadData];
                                           [_activityIndicator stopAnimating];
                                           [self getImagesForVenues];
                                       }
                                   }];
                                   
}

- (void)getImagesForVenues
{
    for (int i = 0; i < _venuesSortedByCheckins.count; i++) {
        Venue *venue = _venuesSortedByCheckins[i];
        [Foursquare2 getPhotosForVenue:venue.foursquareId
                                 limit:[NSNumber numberWithInt:1]
                                offset:nil
                              callback:^(BOOL success, id result) {
                                  if (success) {
                                      NSDictionary *photoItem = [result valueForKeyPath:@"response.photos.items"][0];
                                      NSString *imageSize = @"100x100";
                                      NSString *imageURLString = [NSString stringWithFormat:@"%@%@%@",
                                                                  [photoItem objectForKey:@"prefix"],
                                                                  imageSize,
                                                                  [photoItem objectForKey:@"suffix"]];
                                      venue.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLString]]];
                                      NSIndexPath *venueCellIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
                                      [self.tableView reloadRowsAtIndexPaths:@[venueCellIndexPath] withRowAnimation:0];
                                  }
                              }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _venuesSortedByCheckins.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"venue";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Venue *venue = ((Venue * )_venuesSortedByCheckins[indexPath.row]);
    
    cell.textLabel.text = venue.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i checkins, %i here now", venue.checkInCount, venue.numberOfPeopleHereNow];
    cell.imageView.image = venue.image;
    
    return cell;
}

#pragma mark - Location manager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];
            
    [self getFoursquareVenuesWithLatitude:(CGFloat)location.coordinate.latitude
                             andLongitude:(CGFloat)location.coordinate.longitude];
    
    [_locationMananger stopUpdatingLocation];
}

@end
