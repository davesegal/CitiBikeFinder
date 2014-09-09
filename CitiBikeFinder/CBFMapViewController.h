//
//  ViewController.h
//  CitiBikeFinder
//
//  Created by David Segal on 8/30/14.
//  Copyright (c) 2014 dsegal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CBFMapViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *closestStationTableView;

@property (weak, nonatomic) IBOutlet UIView *mapView;

@end

