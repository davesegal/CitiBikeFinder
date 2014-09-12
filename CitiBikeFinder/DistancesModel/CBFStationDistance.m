//
//  CBFStationDistance.m
//
//  Created by   on 9/7/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CBFStationDistance.h"
#import "CBFRows.h"


NSString *const kCBFStationDistanceStatus = @"status";
NSString *const kCBFStationDistanceOriginAddresses = @"origin_addresses";
NSString *const kCBFStationDistanceDestinationAddresses = @"destination_addresses";
NSString *const kCBFStationDistanceRows = @"rows";


@interface CBFStationDistance ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CBFStationDistance



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
            self.status = [self objectOrNilForKey:kCBFStationDistanceStatus fromDictionary:dict];
            self.originAddresses = [self objectOrNilForKey:kCBFStationDistanceOriginAddresses fromDictionary:dict];
            self.destinationAddresses = [self objectOrNilForKey:kCBFStationDistanceDestinationAddresses fromDictionary:dict];
    NSObject *receivedCBFRows = [dict objectForKey:kCBFStationDistanceRows];
    NSMutableArray *parsedCBFRows = [NSMutableArray array];
    if ([receivedCBFRows isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCBFRows) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCBFRows addObject:[CBFRows modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCBFRows isKindOfClass:[NSDictionary class]]) {
       [parsedCBFRows addObject:[CBFRows modelObjectWithDictionary:(NSDictionary *)receivedCBFRows]];
    }

    self.rows = [NSArray arrayWithArray:parsedCBFRows];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.status forKey:kCBFStationDistanceStatus];
    NSMutableArray *tempArrayForOriginAddresses = [NSMutableArray array];
    for (NSObject *subArrayObject in self.originAddresses) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForOriginAddresses addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForOriginAddresses addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForOriginAddresses] forKey:kCBFStationDistanceOriginAddresses];
    NSMutableArray *tempArrayForDestinationAddresses = [NSMutableArray array];
    for (NSObject *subArrayObject in self.destinationAddresses) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForDestinationAddresses addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForDestinationAddresses addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForDestinationAddresses] forKey:kCBFStationDistanceDestinationAddresses];
    NSMutableArray *tempArrayForRows = [NSMutableArray array];
    for (NSObject *subArrayObject in self.rows) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForRows addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForRows addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForRows] forKey:kCBFStationDistanceRows];

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

    self.status = [aDecoder decodeObjectForKey:kCBFStationDistanceStatus];
    self.originAddresses = [aDecoder decodeObjectForKey:kCBFStationDistanceOriginAddresses];
    self.destinationAddresses = [aDecoder decodeObjectForKey:kCBFStationDistanceDestinationAddresses];
    self.rows = [aDecoder decodeObjectForKey:kCBFStationDistanceRows];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_status forKey:kCBFStationDistanceStatus];
    [aCoder encodeObject:_originAddresses forKey:kCBFStationDistanceOriginAddresses];
    [aCoder encodeObject:_destinationAddresses forKey:kCBFStationDistanceDestinationAddresses];
    [aCoder encodeObject:_rows forKey:kCBFStationDistanceRows];
}

- (id)copyWithZone:(NSZone *)zone
{
    CBFStationDistance *copy = [[CBFStationDistance alloc] init];
    
    if (copy) {

        copy.status = [self.status copyWithZone:zone];
        copy.originAddresses = [self.originAddresses copyWithZone:zone];
        copy.destinationAddresses = [self.destinationAddresses copyWithZone:zone];
        copy.rows = [self.rows copyWithZone:zone];
    }
    
    return copy;
}


@end
