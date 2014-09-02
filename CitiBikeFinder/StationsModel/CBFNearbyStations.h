//
//  CBFNearbyStations.h
//
//  Created by   on 8/30/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CBFNearbyStations : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double nearbyStationsIdentifier;
@property (nonatomic, assign) double distance;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
