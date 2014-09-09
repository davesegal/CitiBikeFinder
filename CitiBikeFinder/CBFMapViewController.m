//
//  ViewController.m
//  CitiBikeFinder
//
//  Created by David Segal on 8/30/14.
//  Copyright (c) 2014 dsegal. All rights reserved.
//

#import "CBFMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CBFApiRequest.h"
#import "CBFStations+StationsSingleton.h"
#import "CBFStationsModels.h"

typedef NS_ENUM(NSInteger, CBFTravelMode)
{
    CBFTravelModeWalking,
    CBFTravelModeBiking
};

@interface CBFMapViewController ()
{
    GMSMapView *googleMapView;
    CLLocationManager *locationManager;
    CLLocation *lastLocation;
    CBFTravelMode mode;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *travelStateControl;
@property (strong, nonatomic) NSArray *closestStations;
@end

@implementation CBFMapViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];

    mode = self.travelStateControl.selectedSegmentIndex;
    
    self.closestStations = [NSArray array];
    
    self.closestStationTableView.delegate = self;
    self.closestStationTableView.dataSource = self;
    
    if([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        //[locationManager startMonitoringSignificantLocationChanges];
        [locationManager startUpdatingLocation];
    }
    CBFMapViewController __block *blockself = self;
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    if (lastLocation.coordinate.longitude == currentLocation.coordinate.longitude && lastLocation.coordinate.latitude == currentLocation.coordinate.latitude)
        return;
    
    NSLog(@"new location %@", lastLocation);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                            longitude:currentLocation.coordinate.longitude
                                                                 zoom:6];
    if (!googleMapView)
    {
        googleMapView = [GMSMapView mapWithFrame:self.mapView.frame camera:camera];
        googleMapView.myLocationEnabled = YES;
        [googleMapView animateToZoom:16];
    }
    else
    {
        [googleMapView animateToLocation:currentLocation.coordinate];
    }
    
    [self.mapView addSubview:googleMapView];
    
    [self placeStationLocations];

    
    lastLocation = [locations lastObject];

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
            //TODO: status authorization denied
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
    
    
    //TODO: - temp fix ... there is a bug where the array gets updated in singleton during enumeration that you need to fix
    CBFStations *stations = [[CBFStations sharedInstance] copy];
    
    double count = 0;
    
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
            ++count;
        }
    }
    
    NSLog(@"Number of locations %f", count);
}

-(void)sortClosestStations
{
    NSMutableArray *stationsArray = [NSMutableArray array];
    CLLocation __block *targetLocation = [[CLLocation alloc] initWithLatitude:lastLocation.coordinate.latitude longitude:lastLocation.coordinate.longitude];
    
    //TODO: - temp fix ... there is a bug where the array gets updated in singleton during enumeration that you need to fix
    CBFStations *stations = [[CBFStations sharedInstance] copy];
    
    for (CBFResults *result in stations.results)
    {
        if ([result.status isEqualToString:@"Active"] && ((mode == CBFTravelModeWalking && result.availableBikes > 0) || (mode == CBFTravelModeBiking && result.availableDocks > 0)))
        {
            [stationsArray addObject:result];
        }
    }
    
    NSArray *sortedStations = [stationsArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        CBFResults *result1 = (CBFResults *)obj1;
        CBFResults *result2 = (CBFResults *)obj2;
        CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:result1.latitude longitude:result1.longitude];
        CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:result2.latitude longitude:result2.longitude];
        
        CLLocationDistance distance1 = [targetLocation distanceFromLocation:loc1];
        CLLocationDistance distance2 = [targetLocation distanceFromLocation:loc2];
        
        if (distance1 < distance2)
            return (NSComparisonResult)NSOrderedAscending;
        else if ( distance1 > distance2)
            return (NSComparisonResult)NSOrderedDescending;
        else
            return (NSComparisonResult)NSOrderedSame;

    }];
    
    self.closestStations = [sortedStations copy];
    [self.closestStationTableView reloadData];
}



- (IBAction)findClosestStations:(id)sender
{
    [self sortClosestStations];
}

-(void)getDirectionsToLocation
{
    //TODO: implement on selection google api to get distances
    CLLocationCoordinate2D loc = {lastLocation.coordinate.latitude, lastLocation.coordinate.longitude};
    [[CBFApiRequest sharedInstance] findDistancesForOrigin:loc  withMode:@"walking" completionSuccess:^(id data) {
        
    } completionFailure:^(NSError *error) {
        
    }];
}

- (IBAction)travelStateChanged:(id)sender
{
    if(self.travelStateControl.selectedSegmentIndex != mode)
    {
        mode = self.travelStateControl.selectedSegmentIndex;
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.closestStations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"myCell"];
        cell.selectionStyle = UITableViewCellStyleSubtitle;
    }
    
    CBFResults *result = self.closestStations[indexPath.row];
    
    cell.textLabel.text = result.label;
    
    if (mode == CBFTravelModeBiking)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"docks available: %d", (int)result.availableDocks];
    }
    else if (mode == CBFTravelModeWalking)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"bikes available: %d", (int)result.availableBikes];
    }
    
    return cell;
}

@end