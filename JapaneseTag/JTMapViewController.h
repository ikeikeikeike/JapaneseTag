//
//  JTThirdViewController.h
//  JapaneseTag
//
//  Created by tatsuo ikeda on 12/08/14.
//  Copyright (c) 2012年 Tatsuo Ikeda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>



@interface JTMapViewController : UIViewController <MKMapViewDelegate,
    CLLocationManagerDelegate,
    UISearchBarDelegate,
    MKAnnotation
>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISearchBar *search;
@property (strong, nonatomic) CLLocationManager* locationManager;

- (void)setPinToCoordinate:(CLLocation*)location;
- (void)handleLongTap:(UILongPressGestureRecognizer *)recognizer;
@end