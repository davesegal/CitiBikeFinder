//
//  CBFRows.m
//
//  Created by   on 9/7/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CBFRows.h"
#import "CBFElements.h"


NSString *const kCBFRowsElements = @"elements";


@interface CBFRows ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CBFRows



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
    NSObject *receivedCBFElements = [dict objectForKey:kCBFRowsElements];
    NSMutableArray *parsedCBFElements = [NSMutableArray array];
    if ([receivedCBFElements isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCBFElements) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCBFElements addObject:[CBFElements modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCBFElements isKindOfClass:[NSDictionary class]]) {
       [parsedCBFElements addObject:[CBFElements modelObjectWithDictionary:(NSDictionary *)receivedCBFElements]];
    }

    self.elements = [NSArray arrayWithArray:parsedCBFElements];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForElements = [NSMutableArray array];
    for (NSObject *subArrayObject in self.elements) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForElements addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForElements addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForElements] forKey:kCBFRowsElements];

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

    self.elements = [aDecoder decodeObjectForKey:kCBFRowsElements];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_elements forKey:kCBFRowsElements];
}

- (id)copyWithZone:(NSZone *)zone
{
    CBFRows *copy = [[CBFRows alloc] init];
    
    if (copy) {

        copy.elements = [self.elements copyWithZone:zone];
    }
    
    return copy;
}


@end
