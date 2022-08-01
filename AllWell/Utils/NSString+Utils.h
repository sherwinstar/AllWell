//
//  NSString+Utils.h
//  Master
//
//  Created by kiefer on 15/11/20.
//  Copyright © 2015年 Neo Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSString (Utils)

/**
 *  转成jsonObject
 */
- (id)toJsonObject;
/**
 *  url问号后面参数转成字典
 */
- (NSDictionary *)toQueryDictionary;
/**
 *  判断是否含有表情符号
 */
- (BOOL)containsEmoji;
/**
 *  去除字符串里的表情符号
 */
- (NSString *)trim_emoji;
/**
 *  去除首尾空格和换行符
 */
- (NSString *)trim_whitespaceAndNewline;
- (NSString *)trim_whitespace;
- (NSString *)trim_space;
/**
 *  由于和kerkee框架里面NSString(KCStringAdditions)方法名冲突
 */
- (NSString *)ggj_trim:(NSString *)string;

- (NSString *)appendSpaceToHead:(CGFloat)width;

@end
