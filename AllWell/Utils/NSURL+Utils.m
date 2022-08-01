//
//  NSURL+Utils.m
//  GlobalScanner
//
//  Created by kiefer on 2018/5/11.
//  Copyright © 2018年 xiaojian. All rights reserved.
//

#import "NSURL+Utils.h"
#import "NSDictionary+Utils.h"
#import "NSString+Utils.h"

@implementation NSURL (Utils)

- (BOOL)isRemoteURL {
    if (self.scheme.length == 0 || self.host.length == 0) {
        return false;
    }
    return ([self.scheme isEqualToString:@"http"] || [self.scheme isEqualToString:@"https"]);
}

- (NSString *)absoluteStringWithoutQuery {
    NSArray *parts = [self.absoluteString componentsSeparatedByString:@"?"];
    return parts.firstObject;
}

// 兼容URL中带路由的情况 eg.
- (NSString *)yh_query {
    NSRange range = [self.absoluteString rangeOfString:@"?"];
    if (range.location == NSNotFound) return @"";
    
    NSArray *parts = [self.absoluteString componentsSeparatedByString:@"?"];
    return parts[1];
}

@end
