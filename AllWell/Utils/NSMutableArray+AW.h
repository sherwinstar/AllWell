//
//  NSMutableArray+GGJ.h
//  GJMapComponent
//
//  Created by szhou on 2019/7/3.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (AW)


- (void)addSafeObject:(id)object;

- (void)insertSafeObject:(id)anObject atIndex:(NSUInteger)index;

- (void)addObjectsFromSafeArray:(NSArray *)otherArray;


@end
