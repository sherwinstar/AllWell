//
//  HCUserInfo.m
//  HIPC
//
//  Created by Shaolin Zhou on 2022/5/4.
//

#import "AWDataHelper.h"

@implementation AWDataHelper

+ (instancetype)shared {
    static AWDataHelper *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (BOOL)hasLogined {
    if (self.user && self.user.AccessToken.length) {
        return YES;
    } else {
        return NO;
    }
}

- (void)logout {
    self.user = nil;
}


@end
