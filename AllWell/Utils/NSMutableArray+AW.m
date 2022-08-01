//
//  NSMutableArray+GGJ.m
//  GJMapComponent
//
//  Created by szhou on 2019/7/3.
//
//

#import "NSMutableArray+AW.h"

@implementation NSMutableArray (AW)


- (void)addSafeObject:(id)anObject
{
    if (anObject) {
        [self addObject:anObject];
    }
}

- (void)insertSafeObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject) {
        [self insertObject:anObject atIndex:index];
    }
}

- (void)addObjectsFromSafeArray:(NSArray *)otherArray
{
    if (otherArray && otherArray.count > 0) {
        [self addObjectsFromArray:otherArray];
    }
}


@end
