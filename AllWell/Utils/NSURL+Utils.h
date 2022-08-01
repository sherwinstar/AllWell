//
//  NSURL+Utils.h
//  GlobalScanner
//
//  Created by kiefer on 2018/5/11.
//  Copyright © 2018年 xiaojian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Utils)

/**
 *  是否为远程链接
 */
- (BOOL)isRemoteURL;

- (NSString *)absoluteStringWithoutQuery;

// 兼容URL中带路由的情况 eg.
- (NSString *)yh_query;

@end
