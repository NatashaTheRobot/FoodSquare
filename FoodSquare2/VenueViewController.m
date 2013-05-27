//
//  VenueViewController.m
//  FoodSquare2
//
//  Created by Natasha Murashev on 5/23/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "VenueViewController.h"
#import "WebViewController.h"

@interface VenueViewController ()
{
    __weak IBOutlet UIImageView *__imageView;
    __weak IBOutlet UILabel *__addressLabel;
    __weak IBOutlet UILabel *__checkinsLabel;
}

- (IBAction)showMenuWithButton:(id)sender;
- (IBAction)reserveWithButton:(id)sender;

@end

@implementation VenueViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    __imageView.image = self.venue.image;
    __addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@ %d", self.venue.address, self.venue.city, self.venue.state, self.venue.zipCode];
    __checkinsLabel.text = [NSString stringWithFormat:@"%i checkins, %i here now", self.venue.checkInCount, self.venue.numberOfPeopleHereNow];
    self.navigationItem.title = self.venue.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"menu"]) {
        ((WebViewController *)segue.destinationViewController).url = self.venue.menuURL;
    } else {
        ((WebViewController *)segue.destinationViewController).url = self.venue.reservationURL;
    }
    
}

@end
