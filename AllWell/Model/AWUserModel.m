//
//  YCUserModel.m
//  HIPC
//
//  Created by Shaolin Zhou on 2022/5/4.
//

#import "AWUserModel.h"

@implementation AWUserModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"token_type" :@"token-type",
             @"user_id" : @"user-id"
    };
}

@end
