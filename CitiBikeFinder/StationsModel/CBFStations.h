//
//  CBFStations.h
//
//  Created by   on 8/30/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CBFStations : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double activeStations;
@property (nonatomic, strong) NSArray *meta;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, assign) BOOL ok;
@property (nonatomic, assign) double totalStations;
@property (nonatomic, assign) double lastUpdate;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
