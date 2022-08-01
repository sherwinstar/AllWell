//
//  NSDictionary+Utils.m
//  GlobalScanner
//
//  Created by kiefer on 2018/5/11.
//  Copyright © 2018年 xiaojian. All rights reserved.
//

#import "NSDictionary+Utils.h"

@implementation NSDictionary (Utils)

- (NSString *)toJsonString {
    if (!self) return nil;
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (error) {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
    return jsonString;
}

@end
