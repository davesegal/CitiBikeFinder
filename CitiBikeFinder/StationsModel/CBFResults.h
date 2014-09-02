//
//  CBFResults.h
//
//  Created by   on 8/30/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CBFResults : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *stationAddress;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double resultsIdentifier;
@property (nonatomic, assign) double availableBikes;
@property (nonatomic, assign) double availableDocks;
@property (nonatomic, assign) double latitude;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSArray *nearbyStations;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
