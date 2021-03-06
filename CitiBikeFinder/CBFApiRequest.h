//
//  CBFApiRequest.h
//  CitiBikeFinder
//
//  Created by David Segal on 8/30/14.
//  Copyright (c) 2014 dsegal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class CBFStations;

@interface CBFApiRequest : NSObject <NSURLSessionDelegate>

+(instancetype)sharedInstance;

-(void)getStations:(BOOL)updateOnly success:(void(^)(CBFStations *))success failure:(void(^)(NSError *))failure;

-(void)findDistancesFromOrigin:(CLLocationCoordinate2D)origin toStations:(CBFStations *)stations withMode:(NSString *)mode completionSuccess:(void(^)(id))success completionFailure:(void(^)(NSError *))failure;

@end
