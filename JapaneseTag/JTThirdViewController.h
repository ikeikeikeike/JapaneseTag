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

@interface JTThirdViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>


@property (nonatomic) IBOutlet MKMapView *mapView;
@end
