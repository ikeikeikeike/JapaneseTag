//
//  JTThirdViewController.m
//  JapaneseTag
//
//  Created by tatsuo ikeda on 12/08/14.
//  Copyright (c) 2012年 Tatsuo Ikeda. All rights reserved.
//

#import "JTMapViewController.h"


@interface JTMapViewController ()
@end


@implementation JTMapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
    /* map */
//    self.mapView.mapType = MKMapTypeHybrid;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.mapView.userLocation addObserver:self forKeyPath:@"location" options:0 context:NULL];
    
    /* initial default location(annotation). */
    // Add method
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(handleLongTap:)];
    recognizer.minimumPressDuration = .8;
    [self.mapView addGestureRecognizer:recognizer];
    recognizer = nil;
    
    // pin
    [self setPinToCoordinate:self.locationManager.location];
    
    
    /* search */
    self.search.showsCancelButton = YES;
}


- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setSearch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - location
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
    [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
}


#pragma mark - map
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    /* Oops Pin */
    
#ifdef DEBUG_ANNOTATION
    NSLog(@"viewForAnnotation");
#endif
    // userlocation is nil
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc]
                                           initWithAnnotation:annotation reuseIdentifier:@"LongTapAnnotation"];
    
    [annotationView setPinColor:MKPinAnnotationColorGreen];
    [annotationView setAnimatesDrop:YES];
    [annotationView setCanShowCallout:YES];
    [annotationView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
    
    //UIImage *pinImage = [UIImage imageNamed:@"pin-image.png"];
    //[annotationView setImage:pinImage];
    
    annotationView.annotation = annotation;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    /* Pin Detail */
    
    NSMutableString *message;
    message = [NSMutableString string];

//    [message appendFormat:@"SubTitle: %@\n", view.annotation.subtitle];
    [message appendFormat:@"Title: %@\n", view.annotation.title];
    [message appendFormat:@"Latitude: %f\n", view.annotation.coordinate.latitude];
    [message appendFormat:@"Longitude: %f\n", view.annotation.coordinate.longitude];
        
    // View alert
    UIAlertView* alertView;
    alertView = [[UIAlertView alloc] initWithTitle:@"Log Info"
                                           message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:NULL];
    [alertView show];
}



#pragma mark - SearchBar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // tap Search Bar

#ifdef DEBUG_SEARCH
    NSLog(@"searchBarTextDidBeginEditing - %@", searchBar.text);
#endif
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // searchText

#ifdef DEBUG_SEARCH
    NSLog(@"searchBar - %@", searchText);
#endif
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // search
    
#ifdef DEBUG_SEARCH
    NSLog(@"searchBarSearchButtonClicked - %@", searchBar.text);
#endif
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // Cancel
    
#ifdef DEBUG_SEARCH
    NSLog(@"searchBarCancelButtonClicked - %@", searchBar.text);
#endif
    [searchBar resignFirstResponder]; 
}


#pragma mark - userfuncs
- (void)setPinToCoordinate:(CLLocation*)location
{
    /* My Default Location */
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    CLLocationCoordinate2D centerCoordinate = location.coordinate;
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMake(centerCoordinate, span);
    [self.mapView setRegion:coordinateRegion animated:YES];
    
    return;
}

- (void)handleLongTap:(UILongPressGestureRecognizer *)recognizer
{
    /* Pinをザクザク刺す */
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        CGPoint point = [recognizer locationInView:self.mapView];
        
        // get coordinate point from map
        CLLocationCoordinate2D coord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
#ifdef DEBUG_ANNOTATION
        float latitude = coord.latitude;
        float longitude = coord.longitude;
        NSLog(@"%@:%f %@:%f", @"longitude:",longitude,@"latitude",latitude);
#endif
        
        // TODO: Geo deprecated 
        MKReverseGeocoder *reverseGeocoder;
        reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coord];
        reverseGeocoder.delegate = self;
        [reverseGeocoder start];
        
        // move animation
//        MKCoordinateRegion region;
//        region.span = MKCoordinateSpanMake(0.05, 0.05);
//        region.center = coord;
//        [self.mapView setRegion:region animated:YES];        
    }
    return;
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark*)placemark
{
#ifdef DEBUG_ANNOTATION
    NSLog(@"title: %@", placemark.title);
#endif
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = placemark.coordinate;
    annotation.title = placemark.title;
    annotation.subtitle = placemark.title;
    
    [self.mapView addAnnotation:annotation];
    
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError*)error
{
    NSLog(@"error");
}


@end
