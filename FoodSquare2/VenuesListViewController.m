//
//  ViewController.m
//  FoodSquare2
//
//  Created by Natasha Murashev on 5/22/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "VenuesListViewController.h"
#import "Venue.h"
#import <QuartzCore/QuartzCore.h>
#import "VenueViewController.h"

@interface VenuesListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VenuesListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setVenues:(NSArray *)venues
{
    _venues = venues;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"venue";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Venue *venue = ((Venue * )self.venues[indexPath.row]);
    
    cell.textLabel.text = venue.name;
    cell.detailTextLabel.text = [venue subtitleText];
    
    cell.imageView.image = venue.image;    
    cell.imageView.layer.cornerRadius = 7;
    cell.imageView.layer.masksToBounds = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"venuesToVenue" sender:self];
}

- (void)reloadChangedImageForCellAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSUInteger selectedRow = ((NSIndexPath *)[self.tableView indexPathForSelectedRow]).row;
    ((VenueViewController *)segue.destinationViewController).venue = self.venues[selectedRow];
}

@end
