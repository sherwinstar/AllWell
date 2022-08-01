//
//  NSMutableDictionary+GGJ.h
//  GJMapComponent
//
//  Created by szhou on 2019/7/3.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (AW)

- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end
