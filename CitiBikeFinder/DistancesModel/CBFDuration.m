//
//  CBFDuration.m
//
//  Created by   on 9/7/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CBFDuration.h"


NSString *const kCBFDurationValue = @"value";
NSString *const kCBFDurationText = @"text";


@interface CBFDuration ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CBFDuration

@synthesize value = _value;
@synthesize text = _text;


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
            self.value = [[self objectOrNilForKey:kCBFDurationValue fromDictionary:dict] doubleValue];
            self.text = [self objectOrNilForKey:kCBFDurationText fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.value] forKey:kCBFDurationValue];
    [mutableDict setValue:self.text forKey:kCBFDurationText];

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

    self.value = [aDecoder decodeDoubleForKey:kCBFDurationValue];
    self.text = [aDecoder decodeObjectForKey:kCBFDurationText];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_value forKey:kCBFDurationValue];
    [aCoder encodeObject:_text forKey:kCBFDurationText];
}

- (id)copyWithZone:(NSZone *)zone
{
    CBFDuration *copy = [[CBFDuration alloc] init];
    
    if (copy) {

        copy.value = self.value;
        copy.text = [self.text copyWithZone:zone];
    }
    
    return copy;
}


@end
