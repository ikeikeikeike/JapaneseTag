//
//  JTThirdViewController.m
//  JapaneseTag
//
//  Created by tatsuo ikeda on 12/08/14.
//  Copyright (c) 2012年 Tatsuo Ikeda. All rights reserved.
//

#import "JTMapViewController.h"


@interface SimpleAnnotation ()
@end

@implementation SimpleAnnotation
@synthesize location;

#pragma mark -
#pragma mark MKAnnotation
- (CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}

- (NSString*)title
{
    return @"Hello!";
}

@end



@interface JTMapViewController ()
@end

@implementation JTMapViewController
@synthesize mapView = _mapView;
@synthesize search = _search;
@synthesize locationManager = _locationManager;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
    //// map
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.mapView.userLocation addObserver:self forKeyPath:@"location" options:0 context:NULL];
    
    // initial default location.
    [self setPinToCoordinate:self.locationManager.location];
    
    
    // search
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
    // 一度しか現在地に移動しないなら removeObserver する
    [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
}

- (void)setPinToCoordinate:(CLLocation*)location
{
    SimpleAnnotation* annotation = [[SimpleAnnotation alloc] init];
    annotation.location = self.locationManager.location;
    [self.mapView addAnnotation:annotation];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
    CLLocationCoordinate2D centerCoordinate = location.coordinate;
    MKCoordinateRegion coordinateRegion =
    MKCoordinateRegionMake(centerCoordinate, span);
    [self.mapView setRegion:coordinateRegion animated:YES];
}


#pragma mark - SearchBar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //Search Barがタップされたときの処理を実装する.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //searchTextを用いて、検索処理を実装する.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //決定時の処理を実装.
    
    [searchBar resignFirstResponder];  //元のViewに戻る.
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //Cancel時の処理を実装.
    
    [searchBar resignFirstResponder];  //元のViewに戻る.
}


@end
