//
//  JTThirdViewController.m
//  JapaneseTag
//
//  Created by tatsuo ikeda on 12/08/14.
//  Copyright (c) 2012年 Tatsuo Ikeda. All rights reserved.
//

#import "JTThirdViewController.h"


@interface JTThirdViewController ()
@end

@implementation JTThirdViewController


@synthesize mapView;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    [mapView.userLocation addObserver:self forKeyPath:@"location" options:0 context:NULL];
}


- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setMapView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    mapView.centerCoordinate = mapView.userLocation.location.coordinate;
    // 一度しか現在地に移動しないなら removeObserver する
    [mapView.userLocation removeObserver:self forKeyPath:@"location"];
}


@end
