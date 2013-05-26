//
//  ViewController.m
//  FoodSquare2
//
//  Created by Natasha Murashev on 5/23/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "ViewController.h"
#import "Foursquare2.h"
#import "Venue.h"
#import "VenuesListViewController.h"
#import "VenueMapViewController.h"

@interface ViewController ()
{
    __weak IBOutlet UIView *__venueListContainer;
    __weak IBOutlet UIView *__mapViewContainer;
    __weak IBOutlet UIActivityIndicatorView *__activityIndicator;
    
    NSArray *_venuesSortedByCheckins;
    CLLocationManager *_locationMananger;
}

- (void)getFoursquareVenuesWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude;
- (IBAction)mapListViewToggle:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar
            setBackgroundImage:[UIImage imageNamed:@"navBar.png"]
            forBarMetrics:UIBarMetricsDefault];
    
    _locationMananger = [[CLLocationManager alloc] init];
    _locationMananger.delegate = self;
    
    __activityIndicator.hidesWhenStopped = YES;
    [__activityIndicator startAnimating];
    [_locationMananger startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Foursquare API Calls

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
                                           
                                           for (UIViewController *viewController in self.childViewControllers) {
                                               if ([viewController isKindOfClass:[VenuesListViewController class]]) {
                                                   ((VenuesListViewController *)viewController).venues = _venuesSortedByCheckins;
                                               } else if ([viewController isKindOfClass:[VenueMapViewController class]]){
                                                   ((VenueMapViewController*)viewController).venues = _venuesSortedByCheckins;
                                               }
                                           }
                                           
                                           [__activityIndicator stopAnimating];
                                           [self getImagesForVenues];
                                       }
                                   }];
    
}

#pragma mark - Image Requests
- (void)downloadImage:(NSURL *)url withIndex:(NSInteger)index
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   ((Venue *)_venuesSortedByCheckins[index]).image = image;
                                   
                                   for (UIViewController *viewController in self.childViewControllers) {
                                       if ([viewController isKindOfClass:[VenuesListViewController class]]) {
                                           NSIndexPath *venueCellIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
                                           [(VenuesListViewController *)viewController reloadChangedImageForCellAtIndexPath:venueCellIndexPath];
                                       } else if ([viewController isKindOfClass:[VenueMapViewController class]]){
                                           // TODO reload image in map view
                                       }
                                   }
                                   
                               } else {
                                   NSLog(@"%@", error);
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
                                      NSString *imageSize = @"300x200";
                                      NSString *imageURLString = [NSString stringWithFormat:@"%@%@%@",
                                                                  [photoItem objectForKey:@"prefix"],
                                                                  imageSize,
                                                                  [photoItem objectForKey:@"suffix"]];
                                      [self downloadImage:[NSURL URLWithString:imageURLString] withIndex:i];
                                    }
                            }];
    }
}

#pragma mark - Actions

- (IBAction)mapListViewToggle:(UIBarButtonItem *)barButton
{
    if ([barButton.title isEqualToString:@"List"]) {
        [self transitionFromViewController:self.childViewControllers[0]
                          toViewController:self.childViewControllers[1]
                                  duration:0.7
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:nil
                                completion:^(BOOL finished) {
                                    barButton.title = @"Map";
                                }];
    } else {
        [self transitionFromViewController:self.childViewControllers[1]
                          toViewController:self.childViewControllers[0]
                                  duration:0.7
                                   options:UIViewAnimationOptionTransitionFlipFromRight
                                animations:nil
                                completion:^(BOOL finished) {
                                    barButton.title = @"List";
                                }];
    }
}

#pragma mark - Location manager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];
        
    for (UIViewController *viewController in self.childViewControllers) {
        if ([viewController isKindOfClass:[VenueMapViewController class]]) {
            ((VenueMapViewController *)viewController).location = location;
        }
    }
    
    [self getFoursquareVenuesWithLatitude:(CGFloat)location.coordinate.latitude
                             andLongitude:(CGFloat)location.coordinate.longitude];
    
    [_locationMananger stopUpdatingLocation];
}

@end
