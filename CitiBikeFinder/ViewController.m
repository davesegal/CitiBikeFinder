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
#import "CBFStations+StationsSingleton.h"
#import "CBFStationsModels.h"

@interface ViewController ()
{
    GMSMapView *googleMapView;
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        [locationManager startMonitoringSignificantLocationChanges];
        //[locationManager startUpdatingLocation];
    }
    ViewController __block *blockself = self;
    [[CBFApiRequest sharedInstance] getStations:NO success:^(CBFStations *stations)
    {
        if (blockself)
        {
            [blockself placeStationLocations];
        }
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [self placeStationLocations];
//        });
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
    CLLocation *location = [locations lastObject];
    
    NSLog(@"new location %@", location);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                            longitude:location.coordinate.longitude
                                                                 zoom:6];
    googleMapView = [GMSMapView mapWithFrame:self.mapView.frame camera:camera];
    googleMapView.myLocationEnabled = YES;
    [googleMapView animateToZoom:16];
    [self.mapView addSubview:googleMapView];
    
    [self placeStationLocations];

//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = location.coordinate;
//    marker.title = @"My location";
//    marker.snippet = @"biking";
//    marker.map = googleMapView;
    
    
    
    


}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"location manager auth change status %u", status);
    switch (status) {
        case kCLAuthorizationStatusDenied:
            // TODO : status authorization denied
            break;
            
        default:
            break;
    }
    
}

-(void)placeStationLocations
{
    GMSVisibleRegion visibleRegion = [googleMapView.projection visibleRegion];
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc]initWithRegion:visibleRegion];
    //GMSMarker *resultMarker = [[GMSMarker alloc]init];
    
    CBFStations *stations = [CBFStations sharedInstance];
    
    
    for (CBFResults *result in stations.results)
    {
        CLLocationCoordinate2D location = {result.latitude, result.longitude};
        //resultMarker = [markerArray objectAtIndex:i];
        if ([bounds containsCoordinate:location])
        {
            GMSMarker *marker = [GMSMarker markerWithPosition:location];
            marker.title = result.stationAddress;
            marker.flat = YES;
            marker.map = googleMapView;
        }
    }
}


@end