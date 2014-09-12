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
#import "CBFStationsModels.h"
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, CBFTravelMode)
{
    CBFTravelModeWalking,
    CBFTravelModeBiking,
    CBFTravelModeShowAll
};

@interface CBFMapViewController()

@property (weak, nonatomic) IBOutlet UISegmentedControl *travelStateControl;
@property (strong, nonatomic) NSArray *closestStations;
@property (strong, nonatomic) CBFStations *allStations;
@property (strong, nonatomic) NSMutableDictionary *markers;
@property (assign, nonatomic) CBFTravelMode mode;
@property (strong, nonatomic) GMSMapView *googleMapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *lastLocation;

@end

@implementation CBFMapViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];

    self.mode = self.travelStateControl.selectedSegmentIndex;
    
    self.closestStations = [NSArray array];
    self.markers = [NSMutableDictionary dictionary];
    
    self.closestStationTableView.delegate = self;
    self.closestStationTableView.dataSource = self;
    
    if([CLLocationManager locationServicesEnabled])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        //[locationManager startMonitoringSignificantLocationChanges];
        self.locationManager.distanceFilter = 50;
        [self.locationManager startUpdatingLocation];
    }
    
    [self getStationData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    if (self.lastLocation.coordinate.longitude == currentLocation.coordinate.longitude && self.lastLocation.coordinate.latitude == currentLocation.coordinate.latitude)
        return;
    
    //NSLog(@"new location %@", self.lastLocation);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                            longitude:currentLocation.coordinate.longitude
                                                                 zoom:6];
    if (!self.googleMapView)
    {
        self.googleMapView = [GMSMapView mapWithFrame:self.mapView.frame camera:camera];
        self.googleMapView.myLocationEnabled = YES;
        [self.googleMapView animateToZoom:16];
    }
    else
    {
        [self.googleMapView animateToLocation:currentLocation.coordinate];
    }
    
    [self.mapView addSubview:self.googleMapView];
    
    if (self.allStations)
        [self placeStationLocations:self.allStations highlightResult:nil];
    
    self.lastLocation = [locations lastObject];

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

-(void)getStationData
{
    CBFMapViewController __block *blockself = self;
    [[CBFApiRequest sharedInstance] getStations:NO success:^(CBFStations *stations)
     {
         if (blockself)
         {
             blockself.allStations = stations;
             [blockself placeStationLocations:stations highlightResult:nil];
             [blockself sortClosestStations:stations];
             
         }
         //
     } failure:^(NSError *error)
     {
         
         
     }];
}

-(void)placeStationLocations:(CBFStations *)stations highlightResult:(CBFStationData *)selectedStationData
{
    
    GMSVisibleRegion visibleRegion = [self.googleMapView.projection visibleRegion];
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc]initWithRegion:visibleRegion];
    
    double count = 0;
    
    for (CBFStationData *stationData in stations.results)
    {
        CLLocationCoordinate2D coordinate = {stationData.latitude, stationData.longitude};
        NSValue *key = [NSValue valueWithMKCoordinate:coordinate];
        //resultMarker = [markerArray objectAtIndex:i];
        if ([bounds containsCoordinate:coordinate])
        {
            GMSMarker *marker = nil;
            if (self.markers[key])
            {
                marker = self.markers[key];
            }
            else
            {
                marker = [GMSMarker markerWithPosition:coordinate];
                [self.markers setObject:marker forKey:key];
            }
            
            marker.title = stationData.stationAddress;
            marker.flat = YES;
            marker.map = self.googleMapView;
            if([stationData.label isEqualToString:selectedStationData.label])
            {
                marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
            }
            else
            {
                marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
            }
            marker.opacity = ([self isStationAvailable:stationData]) ? 1.0 : 0.3;
            ++count;
        }
    }
    
    NSLog(@"Number of locations %f", count);
}

-(void)sortClosestStations:(CBFStations *)stations
{
    NSMutableArray *stationsArray = [NSMutableArray array];
    CLLocation __block *targetLocation = [[CLLocation alloc] initWithLatitude:self.lastLocation.coordinate.latitude longitude:self.lastLocation.coordinate.longitude];
    
    for (CBFStationData *result in stations.results)
    {
        if ([result.status isEqualToString:@"Active"] && ((self.mode == CBFTravelModeWalking && result.availableBikes > 0) || (self.mode == CBFTravelModeBiking && result.availableDocks > 0)))
        {
            [stationsArray addObject:result];
        }
    }
    
    NSArray *sortedStations = [stationsArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        CBFStationData *result1 = (CBFStationData *)obj1;
        CBFStationData *result2 = (CBFStationData *)obj2;
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
    
    self.closestStations = [NSArray array];
    self.closestStations = [sortedStations copy];
    [self.closestStationTableView reloadData];
}

-(void)getDirectionsToLocation
{
    //TODO: implement on selection google api to get distances
//    CLLocationCoordinate2D loc = {lastLocation.coordinate.latitude, lastLocation.coordinate.longitude};
//    [[CBFApiRequest sharedInstance] findDistancesForOrigin:loc  withMode:@"walking" completionSuccess:^(id data) {
//        
//    } completionFailure:^(NSError *error) {
//        
//    }];
}


-(BOOL)isStationAvailable:(CBFStationData *)stationData
{
    if (![stationData.status isEqualToString:@"Active"])
    {
        return NO;
    }
    
    if (self.mode == CBFTravelModeBiking && stationData.availableDocks > 0)
    {
        return YES;
    }
    
    if (self.mode == CBFTravelModeWalking && stationData.availableBikes > 0)
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - UIButton actions

- (IBAction)findClosestStations:(id)sender
{
    [self.googleMapView animateToLocation:self.lastLocation.coordinate];
    [self.locationManager startUpdatingLocation];
    [self getStationData];
}



#pragma mark - UISegmentedControl action

- (IBAction)travelStateChanged:(id)sender
{
    if(self.travelStateControl.selectedSegmentIndex != self.mode)
    {
        [self.googleMapView animateToLocation:self.lastLocation.coordinate];
        [self.locationManager startUpdatingLocation];
        self.mode = self.travelStateControl.selectedSegmentIndex;
        [self getStationData];
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.locationManager stopUpdatingLocation];
    CBFStationData *stationData = self.closestStations[indexPath.row];
    [self.googleMapView animateToLocation:CLLocationCoordinate2DMake(stationData.latitude, stationData.longitude)];
    [self placeStationLocations:self.allStations highlightResult:stationData];
}


#pragma mark - UITableViewDataSource methods

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
    
    CBFStationData *result = self.closestStations[indexPath.row];
    
    cell.textLabel.text = result.label;
    
    if (self.mode == CBFTravelModeBiking)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"docks available: %d", (int)result.availableDocks];
    }
    else if (self.mode == CBFTravelModeWalking)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"bikes available: %d", (int)result.availableBikes];
    }
    
    return cell;
}

@end
