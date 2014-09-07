//
//  CBFApiRequest.m
//  CitiBikeFinder
//
//  Created by David Segal on 8/30/14.
//  Copyright (c) 2014 dsegal. All rights reserved.
//

#import "CBFApiRequest.h"
#import "CBFStations+StationsSingleton.h"
#import "CBFStationsModels.h"
#import "CBFApiKeys.h"


@interface CBFApiRequest()
{
    NSMutableData *_responseData;
}
@end

@implementation CBFApiRequest

//http://appservices.citibikenyc.com/data2/stations.php

//http://appservices.citibikenyc.com/data2/stations.php?updateOnly=true


+(instancetype)sharedInstance
{
    static CBFApiRequest *mySharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mySharedInstance = [[CBFApiRequest alloc] init];
    });
    return mySharedInstance;
}

-(void)getStations:(BOOL)updateOnly success:(void (^)(CBFStations *))success failure:(void (^)(NSError *))failure
{
    NSString *urlString = (updateOnly) ? @"http://appservices.citibikenyc.com/data2/stations.php?updateOnly=true" : @"http://appservices.citibikenyc.com/data2/stations.php";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if (!error)
                                                {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *stationsJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                                                    CBFStations *stationsModel = [[CBFStations sharedInstance] initWithDictionary:stationsJSON];
                                                    NSDate *update = [NSDate dateWithTimeIntervalSince1970:stationsModel.lastUpdate];
                                                    success(stationsModel);
                                                }
                                                else
                                                {
                                                    failure(error);
                                                }
                                                
    }];
    [task resume];
    
}

-(void)findDistancesForOrigin:(CLLocationCoordinate2D)origin withMode:(NSString *)mode completionSuccess:(void(^)(id))success completionFailure:(void(^)(NSError *))failure
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?key=%@&units=imperial&mode=walking&origins=%f,%f&destinations=", CBFApiKeyGoogleDistanceMatrix, origin.latitude, origin.longitude ];
    CBFStations *stations = [CBFStations sharedInstance];
    for (int index = 0; index < 5 && index < [stations.results count]; index++)
    {
        CBFResults *results = stations.results[index];
        [urlString appendString:[NSString stringWithFormat:@"%f,%f|", results.latitude, results.longitude]];
    }
    [urlString deleteCharactersInRange:NSMakeRange([urlString length] - 1, 1)];
    NSString *tStr = [urlString copy];
    NSURL *url = [NSURL URLWithString:[tStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSError *jsonError = nil;
            NSDictionary *distances = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            NSLog(@"success");
        }
        else
        {
            failure(error);
        }
    }];
    [task resume];
}


- (NSString*) convertObjectToJson:(NSObject *) object
{
    NSError *writeError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return result;
}

@end
