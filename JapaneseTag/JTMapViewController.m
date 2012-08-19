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
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTap:)];
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
    // 一度しか現在地に移動しないなら removeObserver する
    [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
}


#pragma mark - map
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    /* Pinの挙動 */
    
#ifdef DEBUG_ANNOTATION
    NSLog(@"viewForAnnotation");
#endif
    // 現在地表示なら nil を返す  
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"LongTap"];
    
    [annotationView setPinColor:MKPinAnnotationColorGreen];
    [annotationView setAnimatesDrop:YES];
    [annotationView setCanShowCallout:YES];  // >　矢印を出すか出さないか
    [annotationView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
    
    //UIImage *pinImage = [UIImage imageNamed:@"pin-image.png"];
    //[annotationView setImage:pinImage];
    
    annotationView.annotation = annotation;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    /* Pinの詳細表示 */
    
    // ログを取得する
//    NSDictionary *logDict;
//    logDict = (view.annotation).logDict;
    
    // メッセージを作成する
//    NSMutableString *message;
//    message = [NSMutableString string];
//    [message appendFormat:@"Date: %@\n", [logDict objectForKey:@"date"]];
//    [message appendFormat:@"Lat: %@\n", [logDict objectForKey:@"latitude"]];
//    [message appendFormat:@"Lon: %@\n", [logDict objectForKey:@"longitude"]];
    
    // アラートを表示する
    UIAlertView* alertView;
//    alertView = [[UIAlertView alloc] initWithTitle:@"Log Info" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:NULL];
//    [alertView autorelease];
    [alertView show];
}


#pragma mark - SearchBar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // Search Barがタップされたときの処理を実装する.

#ifdef DEBUG_SEARCH
    NSLog(@"searchBarTextDidBeginEditing - %@", searchBar.text);
#endif
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // searchTextを用いて、検索処理を実装する.

#ifdef DEBUG_SEARCH
    NSLog(@"searchBar - %@", searchText);
#endif
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 決定時の処理を実装.
    
#ifdef DEBUG_SEARCH
    NSLog(@"searchBarSearchButtonClicked - %@", searchBar.text);
#endif
    
    [searchBar resignFirstResponder];  // 元のViewに戻る.
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // Cancel時の処理を実装.
    
#ifdef DEBUG_SEARCH
    NSLog(@"searchBarCancelButtonClicked - %@", searchBar.text);
#endif
    [searchBar resignFirstResponder];  // 元のViewに戻る.
}


#pragma mark - userfuncs
- (void)setPinToCoordinate:(CLLocation*)location
{
    /* My 初期ロケーション設定 */
    
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
        // move animation
//        MKCoordinateRegion region;
//        region.span = MKCoordinateSpanMake(0.05, 0.05);
//        region.center = coord;
//        [self.mapView setRegion:region animated:YES];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coord;
        annotation.title = @"Title";    // TODO Get annotatoin title by the AnyAPI.
        annotation.subtitle = @"Subtile";    // TODO Get annotation title by the AnyAPI.
        
        [self.mapView addAnnotation:annotation];
    }
    return;
}

@end
