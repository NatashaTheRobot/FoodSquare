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
    NSMutableArray *_venues;
    __weak IBOutlet UIActivityIndicatorView *_activityIndicator;
}

- (void)getFoursquareVenues;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _activityIndicator.hidesWhenStopped = YES;
    _venues = [NSMutableArray array];
    [self getFoursquareVenues];
}

- (void)getFoursquareVenues
{
    [_activityIndicator startAnimating];
    [Foursquare2 searchVenuesNearByLatitude:[NSNumber numberWithFloat:37.78063]
                                  longitude:[NSNumber numberWithFloat:-122.389625]
                                 accuracyLL:nil
                                   altitude:nil
                                accuracyAlt:nil
                                      query:nil
                                      limit:[NSNumber numberWithInt:50]
                                 categoryId:@"4d4b7105d754a06374d81259"
                                     intent:0
                                     radius:[NSNumber numberWithInt:800]
                                   callback:^(BOOL success, id result) {
                                       
                                       NSArray *venuesArray = [result valueForKeyPath:@"response.venues"];
                                       
                                       for (NSDictionary *venue in venuesArray) {
                                           
                                           Venue *newVenue = [[Venue alloc] init];
                                           
                                           newVenue.name = [venue objectForKey:@"name"];
                                           newVenue.numberOfPeopleHereNow = [venue valueForKeyPath:@"hereNow.count"];
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
                                           
                                           [_venues addObject:newVenue];
                                       }
                                       
                                       [self.tableView reloadData];
                                       [_activityIndicator stopAnimating];
                                   }];
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
    return _venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"venue";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = ((Venue * )_venues[indexPath.row]).name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i checkins", ((Venue * )_venues[indexPath.row]).checkInCount];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
