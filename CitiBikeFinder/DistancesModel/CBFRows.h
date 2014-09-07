//
//  CBFRows.h
//
//  Created by   on 9/7/14
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CBFRows : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *elements;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
