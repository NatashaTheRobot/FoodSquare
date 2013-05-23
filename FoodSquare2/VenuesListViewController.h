//
//  ViewController.h
//  FoodSquare2
//
//  Created by Natasha Murashev on 5/22/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenuesListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *venues;

- (void)reloadChangedImageForCellAtIndexPath:(NSIndexPath *)indexPath;

@end
