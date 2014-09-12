//
//  CBFResults.m
//
//  Created by   on 8/30/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CBFStationData.h"
#import "CBFNearbyStations.h"


NSString *const kCBFResultsStatus = @"status";
NSString *const kCBFResultsStationAddress = @"stationAddress";
NSString *const kCBFResultsLongitude = @"longitude";
NSString *const kCBFResultsId = @"id";
NSString *const kCBFResultsAvailableBikes = @"availableBikes";
NSString *const kCBFResultsAvailableDocks = @"availableDocks";
NSString *const kCBFResultsLatitude = @"latitude";
NSString *const kCBFResultsLabel = @"label";
NSString *const kCBFResultsNearbyStations = @"nearbyStations";


@interface CBFStationData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CBFStationData



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
            self.status = [self objectOrNilForKey:kCBFResultsStatus fromDictionary:dict];
            self.stationAddress = [self objectOrNilForKey:kCBFResultsStationAddress fromDictionary:dict];
            self.longitude = [[self objectOrNilForKey:kCBFResultsLongitude fromDictionary:dict] doubleValue];
            self.resultsIdentifier = [[self objectOrNilForKey:kCBFResultsId fromDictionary:dict] doubleValue];
            self.availableBikes = [[self objectOrNilForKey:kCBFResultsAvailableBikes fromDictionary:dict] doubleValue];
            self.availableDocks = [[self objectOrNilForKey:kCBFResultsAvailableDocks fromDictionary:dict] doubleValue];
            self.latitude = [[self objectOrNilForKey:kCBFResultsLatitude fromDictionary:dict] doubleValue];
            self.label = [self objectOrNilForKey:kCBFResultsLabel fromDictionary:dict];
    NSObject *receivedCBFNearbyStations = [dict objectForKey:kCBFResultsNearbyStations];
    NSMutableArray *parsedCBFNearbyStations = [NSMutableArray array];
    if ([receivedCBFNearbyStations isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCBFNearbyStations) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCBFNearbyStations addObject:[CBFNearbyStations modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCBFNearbyStations isKindOfClass:[NSDictionary class]]) {
       [parsedCBFNearbyStations addObject:[CBFNearbyStations modelObjectWithDictionary:(NSDictionary *)receivedCBFNearbyStations]];
    }

    self.nearbyStations = [NSArray arrayWithArray:parsedCBFNearbyStations];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.status forKey:kCBFResultsStatus];
    [mutableDict setValue:self.stationAddress forKey:kCBFResultsStationAddress];
    [mutableDict setValue:[NSNumber numberWithDouble:self.longitude] forKey:kCBFResultsLongitude];
    [mutableDict setValue:[NSNumber numberWithDouble:self.resultsIdentifier] forKey:kCBFResultsId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.availableBikes] forKey:kCBFResultsAvailableBikes];
    [mutableDict setValue:[NSNumber numberWithDouble:self.availableDocks] forKey:kCBFResultsAvailableDocks];
    [mutableDict setValue:[NSNumber numberWithDouble:self.latitude] forKey:kCBFResultsLatitude];
    [mutableDict setValue:self.label forKey:kCBFResultsLabel];
    NSMutableArray *tempArrayForNearbyStations = [NSMutableArray array];
    for (NSObject *subArrayObject in self.nearbyStations) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForNearbyStations addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForNearbyStations addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForNearbyStations] forKey:kCBFResultsNearbyStations];

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

    self.status = [aDecoder decodeObjectForKey:kCBFResultsStatus];
    self.stationAddress = [aDecoder decodeObjectForKey:kCBFResultsStationAddress];
    self.longitude = [aDecoder decodeDoubleForKey:kCBFResultsLongitude];
    self.resultsIdentifier = [aDecoder decodeDoubleForKey:kCBFResultsId];
    self.availableBikes = [aDecoder decodeDoubleForKey:kCBFResultsAvailableBikes];
    self.availableDocks = [aDecoder decodeDoubleForKey:kCBFResultsAvailableDocks];
    self.latitude = [aDecoder decodeDoubleForKey:kCBFResultsLatitude];
    self.label = [aDecoder decodeObjectForKey:kCBFResultsLabel];
    self.nearbyStations = [aDecoder decodeObjectForKey:kCBFResultsNearbyStations];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_status forKey:kCBFResultsStatus];
    [aCoder encodeObject:_stationAddress forKey:kCBFResultsStationAddress];
    [aCoder encodeDouble:_longitude forKey:kCBFResultsLongitude];
    [aCoder encodeDouble:_resultsIdentifier forKey:kCBFResultsId];
    [aCoder encodeDouble:_availableBikes forKey:kCBFResultsAvailableBikes];
    [aCoder encodeDouble:_availableDocks forKey:kCBFResultsAvailableDocks];
    [aCoder encodeDouble:_latitude forKey:kCBFResultsLatitude];
    [aCoder encodeObject:_label forKey:kCBFResultsLabel];
    [aCoder encodeObject:_nearbyStations forKey:kCBFResultsNearbyStations];
}

- (id)copyWithZone:(NSZone *)zone
{
    CBFStationData *copy = [[CBFStationData alloc] init];
    
    if (copy) {

        copy.status = [self.status copyWithZone:zone];
        copy.stationAddress = [self.stationAddress copyWithZone:zone];
        copy.longitude = self.longitude;
        copy.resultsIdentifier = self.resultsIdentifier;
        copy.availableBikes = self.availableBikes;
        copy.availableDocks = self.availableDocks;
        copy.latitude = self.latitude;
        copy.label = [self.label copyWithZone:zone];
        copy.nearbyStations = [self.nearbyStations copyWithZone:zone];
    }
    
    return copy;
}


@end
