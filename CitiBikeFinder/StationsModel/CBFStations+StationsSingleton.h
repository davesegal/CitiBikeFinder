//
//  CBFStations+StationsSingleton.h
//  CitiBikeFinder
//
//  Created by David Segal on 9/5/14.
//  Copyright (c) 2014 dsegal. All rights reserved.
//

#import "CBFStations.h"

@interface CBFStations (StationsSingleton)

+(instancetype)sharedInstance;

-(void)updateStations:(NSArray *)updateData;

@end
