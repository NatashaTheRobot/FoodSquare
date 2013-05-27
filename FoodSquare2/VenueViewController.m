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

    [self disableWebButtonsIfNoURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)disableWebButtonsIfNoURL
{
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            if ([((UIButton *)subview).currentTitle isEqualToString:@"Menu"]) {
                if (!self.venue.menuURL) {
                    ((UIButton *)subview).enabled = NO;
                }
            } else if ([((UIButton *)subview).currentTitle isEqualToString:@"Reserve"]) {
                if (!self.venue.reservationURL) {
                    ((UIButton *)subview).enabled = NO;
                }
            }
                
        }
    }
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
