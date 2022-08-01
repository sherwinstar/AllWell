//
//  NSMutableDictionary+GGJ.m
//  GJMapComponent
//
//  Created by szhou on 2019/7/3.
//
//

#import "NSMutableDictionary+AW.h"

@implementation NSMutableDictionary (AW)


- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }
}

@end
