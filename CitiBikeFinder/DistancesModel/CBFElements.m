//
//  CBFElements.m
//
//  Created by   on 9/7/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CBFElements.h"
#import "CBFDuration.h"
#import "CBFDistance.h"


NSString *const kCBFElementsStatus = @"status";
NSString *const kCBFElementsDuration = @"duration";
NSString *const kCBFElementsDistance = @"distance";


@interface CBFElements ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CBFElements


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
            self.status = [self objectOrNilForKey:kCBFElementsStatus fromDictionary:dict];
            self.duration = [CBFDuration modelObjectWithDictionary:[dict objectForKey:kCBFElementsDuration]];
            self.distance = [CBFDistance modelObjectWithDictionary:[dict objectForKey:kCBFElementsDistance]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.status forKey:kCBFElementsStatus];
    [mutableDict setValue:[self.duration dictionaryRepresentation] forKey:kCBFElementsDuration];
    [mutableDict setValue:[self.distance dictionaryRepresentation] forKey:kCBFElementsDistance];

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

    self.status = [aDecoder decodeObjectForKey:kCBFElementsStatus];
    self.duration = [aDecoder decodeObjectForKey:kCBFElementsDuration];
    self.distance = [aDecoder decodeObjectForKey:kCBFElementsDistance];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_status forKey:kCBFElementsStatus];
    [aCoder encodeObject:_duration forKey:kCBFElementsDuration];
    [aCoder encodeObject:_distance forKey:kCBFElementsDistance];
}

- (id)copyWithZone:(NSZone *)zone
{
    CBFElements *copy = [[CBFElements alloc] init];
    
    if (copy) {

        copy.status = [self.status copyWithZone:zone];
        copy.duration = [self.duration copyWithZone:zone];
        copy.distance = [self.distance copyWithZone:zone];
    }
    
    return copy;
}


@end
