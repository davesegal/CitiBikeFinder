//
//  CBFStations.m
//
//  Created by   on 8/30/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CBFStations.h"
#import "CBFResults.h"


NSString *const kCBFStationsActiveStations = @"activeStations";
NSString *const kCBFStationsMeta = @"meta";
NSString *const kCBFStationsResults = @"results";
NSString *const kCBFStationsOk = @"ok";
NSString *const kCBFStationsTotalStations = @"totalStations";
NSString *const kCBFStationsLastUpdate = @"lastUpdate";


@interface CBFStations ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CBFStations

@synthesize activeStations = _activeStations;
@synthesize meta = _meta;
@synthesize results = _results;
@synthesize ok = _ok;
@synthesize totalStations = _totalStations;
@synthesize lastUpdate = _lastUpdate;


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
            self.activeStations = [[self objectOrNilForKey:kCBFStationsActiveStations fromDictionary:dict] doubleValue];
            self.meta = [self objectOrNilForKey:kCBFStationsMeta fromDictionary:dict];
    NSObject *receivedCBFResults = [dict objectForKey:kCBFStationsResults];
    NSMutableArray *parsedCBFResults = [NSMutableArray array];
    if ([receivedCBFResults isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCBFResults) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCBFResults addObject:[CBFResults modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCBFResults isKindOfClass:[NSDictionary class]]) {
       [parsedCBFResults addObject:[CBFResults modelObjectWithDictionary:(NSDictionary *)receivedCBFResults]];
    }

    self.results = [NSArray arrayWithArray:parsedCBFResults];
            self.ok = [[self objectOrNilForKey:kCBFStationsOk fromDictionary:dict] boolValue];
            self.totalStations = [[self objectOrNilForKey:kCBFStationsTotalStations fromDictionary:dict] doubleValue];
            self.lastUpdate = [[self objectOrNilForKey:kCBFStationsLastUpdate fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.activeStations] forKey:kCBFStationsActiveStations];
    NSMutableArray *tempArrayForMeta = [NSMutableArray array];
    for (NSObject *subArrayObject in self.meta) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForMeta addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForMeta addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMeta] forKey:kCBFStationsMeta];
    NSMutableArray *tempArrayForResults = [NSMutableArray array];
    for (NSObject *subArrayObject in self.results) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForResults addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForResults addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForResults] forKey:kCBFStationsResults];
    [mutableDict setValue:[NSNumber numberWithBool:self.ok] forKey:kCBFStationsOk];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalStations] forKey:kCBFStationsTotalStations];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lastUpdate] forKey:kCBFStationsLastUpdate];

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

    self.activeStations = [aDecoder decodeDoubleForKey:kCBFStationsActiveStations];
    self.meta = [aDecoder decodeObjectForKey:kCBFStationsMeta];
    self.results = [aDecoder decodeObjectForKey:kCBFStationsResults];
    self.ok = [aDecoder decodeBoolForKey:kCBFStationsOk];
    self.totalStations = [aDecoder decodeDoubleForKey:kCBFStationsTotalStations];
    self.lastUpdate = [aDecoder decodeDoubleForKey:kCBFStationsLastUpdate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_activeStations forKey:kCBFStationsActiveStations];
    [aCoder encodeObject:_meta forKey:kCBFStationsMeta];
    [aCoder encodeObject:_results forKey:kCBFStationsResults];
    [aCoder encodeBool:_ok forKey:kCBFStationsOk];
    [aCoder encodeDouble:_totalStations forKey:kCBFStationsTotalStations];
    [aCoder encodeDouble:_lastUpdate forKey:kCBFStationsLastUpdate];
}

- (id)copyWithZone:(NSZone *)zone
{
    CBFStations *copy = [[CBFStations alloc] init];
    
    if (copy) {

        copy.activeStations = self.activeStations;
        copy.meta = [self.meta copyWithZone:zone];
        copy.results = [self.results copyWithZone:zone];
        copy.ok = self.ok;
        copy.totalStations = self.totalStations;
        copy.lastUpdate = self.lastUpdate;
    }
    
    return copy;
}


@end
