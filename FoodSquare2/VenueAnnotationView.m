//
//  VenueAnnotationView.m
//  FoodSquare2
//
//  Created by Natasha Murashev on 5/26/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "VenueAnnotationView.h"

@implementation VenueAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"pin.png"];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
