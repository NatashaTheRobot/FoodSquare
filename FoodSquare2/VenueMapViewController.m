//
//  VenueMapViewController.m
//  FoodSquare2
//
//  Created by Natasha Murashev on 5/23/13.
//  Copyright (c) 2013 Natasha Murashev. All rights reserved.
//

#import "VenueMapViewController.h"
#import "VenueAnnotation.h"
#import "VenueAnnotationView.h"
#import "VenueViewController.h"

@interface VenueMapViewController ()
{
    __weak IBOutlet MKMapView *__mapView;
}
@end

@implementation VenueMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // zoom in on user location!
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLocation:(CLLocation *)location
{
    MKCoordinateSpan span;
    span.latitudeDelta = 0.015;
    span.longitudeDelta = 0.015;
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    MKCoordinateRegion region;
    region.span = span;
    region.center=center;
    
    [__mapView setRegion:region animated:TRUE];
    [__mapView regionThatFits:region];
    
    [self addPinToLocation:center];
}

- (void)addPinToLocation:(CLLocationCoordinate2D)location
{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:location];
    [__mapView addAnnotation:annotation];
}

- (void)setVenues:(NSArray *)venues
{    
    for (Venue *venue in venues) {
        
        VenueAnnotation *venueAnnotation = [[VenueAnnotation alloc] init];
        venueAnnotation.title = venue.name;
        venueAnnotation.subtitle = [venue subtitleText];
        venueAnnotation.coordinate = CLLocationCoordinate2DMake(venue.latitude, venue.longitude);
        venueAnnotation.venue = venue;
        
        [__mapView addAnnotation:venueAnnotation];;
    }
}

- (void)resetAnnotationAtIndex:(NSInteger)index forVenue:(Venue *)venue
{
    // How to remove the matching annotation?!! Do I have to iterate over all the annotations every time?!!
    
    if ([__mapView.annotations[index] isKindOfClass:[VenueAnnotation class]]) {
        
        VenueAnnotation *newVenueAnnotation = [[VenueAnnotation alloc] init];
        newVenueAnnotation.title = venue.name;
        newVenueAnnotation.subtitle = [venue subtitleText];
        newVenueAnnotation.coordinate = CLLocationCoordinate2DMake(venue.latitude, venue.longitude);
        newVenueAnnotation.venue = venue;
            
        [__mapView addAnnotation:newVenueAnnotation];
        
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *venueIdentifier = @"venue";
    NSString *pinIdentifier = @"pin";
    
    MKAnnotationView *annotationView;
    
    if ([annotation isKindOfClass:[VenueAnnotation class]]) {
        annotationView = [__mapView dequeueReusableAnnotationViewWithIdentifier:venueIdentifier];
    } else {
        annotationView = [__mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    }
    
    if (!annotationView) {
        if ([annotation isKindOfClass:[VenueAnnotation class]]) {
            annotationView = [[VenueAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:venueIdentifier];

            CGRect  viewRect = CGRectMake(10, 10, 30, 30);
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:viewRect];
            imageView.image = ((VenueAnnotation *)annotation).venue.image;
            annotationView.leftCalloutAccessoryView = imageView;
        } else {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
            ((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorPurple;
            ((MKPinAnnotationView *)annotationView).animatesDrop = YES;
        }
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
    } else {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    VenueAnnotation *venueAnnotation = [__mapView selectedAnnotations][0];
    ((VenueViewController *)segue.destinationViewController).venue = venueAnnotation.venue;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"mapToVenue" sender:self];
}

@end
