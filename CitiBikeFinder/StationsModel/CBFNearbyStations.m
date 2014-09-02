//
//  CBFNearbyStations.m
//
//  Created by   on 8/30/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CBFNearbyStations.h"


NSString *const kCBFNearbyStationsId = @"id";
NSString *const kCBFNearbyStationsDistance = @"distance";


@interface CBFNearbyStations ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CBFNearbyStations

@synthesize nearbyStationsIdentifier = _nearbyStationsIdentifier;
@synthesize distance = _distance;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.nearbyStationsIdentifier = [[self objectOrNilForKey:kCBFNearbyStationsId fromDictionary:dict] doubleValue];
            self.distance = [[self objectOrNilForKey:kCBFNearbyStationsDistance fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.nearbyStationsIdentifier] forKey:kCBFNearbyStationsId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.distance] forKey:kCBFNearbyStationsDistance];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.nearbyStationsIdentifier = [aDecoder decodeDoubleForKey:kCBFNearbyStationsId];
    self.distance = [aDecoder decodeDoubleForKey:kCBFNearbyStationsDistance];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_nearbyStationsIdentifier forKey:kCBFNearbyStationsId];
    [aCoder encodeDouble:_distance forKey:kCBFNearbyStationsDistance];
}

- (id)copyWithZone:(NSZone *)zone
{
    CBFNearbyStations *copy = [[CBFNearbyStations alloc] init];
    
    if (copy) {

        copy.nearbyStationsIdentifier = self.nearbyStationsIdentifier;
        copy.distance = self.distance;
    }
    
    return copy;
}


@end
