//
//  ViewController.m
//  CitiBikeFinder
//
//  Created by David Segal on 8/30/14.
//  Copyright (c) 2014 dsegal. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CBFApiRequest.h"

@interface ViewController ()
{
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
    CLLocation *lastLocation;
}
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startMonitoringSignificantLocationChanges];
    }
    [[CBFApiRequest sharedInstance] getStations:NO success:^(CBFStations *stations)
    {

    } failure:^(NSError *error)
    {
        
        
    }];
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
//                                                            longitude:151.20
//                                                                 zoom:6];
//    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    mapView_.myLocationEnabled = YES;
//    self.view = mapView_;
//    
//    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
//    marker.map = mapView_;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *object in locations)
    {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:object.coordinate.latitude
                                                                longitude:object.coordinate.longitude
                                                                     zoom:6];
        mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        mapView_.myLocationEnabled = YES;
        [mapView_ animateToZoom:16];
        self.view = mapView_;

        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = object.coordinate;
        marker.title = @"My location";
        marker.snippet = @"biking";
        marker.map = mapView_;
    }
}

@end
