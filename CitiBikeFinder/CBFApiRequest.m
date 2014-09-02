//
//  CBFApiRequest.m
//  CitiBikeFinder
//
//  Created by David Segal on 8/30/14.
//  Copyright (c) 2014 dsegal. All rights reserved.
//

#import "CBFApiRequest.h"
#import "CBFStations.h"

@interface CBFApiRequest()
{
    NSMutableData *_responseData;
}
@end

@implementation CBFApiRequest

//http://appservices.citibikenyc.com/data2/stations.php

//http://appservices.citibikenyc.com/data2/stations.php?updateOnly=true

//AIzaSyC5ON6lQMEI70otsOspweENlp8oltCAG_U - google maps api key

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
                                                    CBFStations *stationsModel = [[CBFStations alloc] initWithDictionary:stationsJSON];
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




@end
