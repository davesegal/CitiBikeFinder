//
//  CBFStations+StationsSingleton.m
//  CitiBikeFinder
//
//  Created by David Segal on 9/5/14.
//  Copyright (c) 2014 dsegal. All rights reserved.
//

#import "CBFStations+StationsSingleton.h"

@implementation CBFStations (StationsSingleton)

+(instancetype)sharedInstance
{
    static CBFStations *mySharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mySharedInstance = [[CBFStations alloc] init];
    });
    return mySharedInstance;
}

-(void) updateStations:(NSArray *)updateData
{
    
}

@end
