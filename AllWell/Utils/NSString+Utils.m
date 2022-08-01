//
//  NSString+Utils.m
//  Master
//
//  Created by kiefer on 15/11/20.
//  Copyright © 2015年 Neo Yang. All rights reserved.
//

#import "NSString+Utils.h"
#import <UIKit/UIKit.h>

@implementation NSString (Utils)

- (id)toJsonObject {
    if (!self || self.length == 0) return nil;
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (error) {
        return nil;
    }
    return jsonObject;
}

- (NSDictionary *)toQueryDictionary {
    if (self.length == 0) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        if (![pair containsString:@"="]) {
            continue;
        }
        NSRange range = [pair rangeOfString:@"=" options:NSCaseInsensitiveSearch];
        NSString *key = [pair substringToIndex:range.location];
        NSString *value = [pair substringFromIndex:range.location + 1];
        if (key && value) {
            [dict setObject:value forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (BOOL)containsEmoji {
    __block BOOL res = false;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    res = true;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                res = true;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                res = true;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                res = true;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                res = true;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                res = true;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                res = true;
            }
        }
    }];
    return res;
}

- (NSString *)lineBreakByTruncatingTail:(CGFloat)maxWidth font:(UIFont *)font {
    if (!self || ![self length]) return self;
    
    CGFloat width = [self sizeWithAttributes:@{NSFontAttributeName:font}].width;
    if (width <= maxWidth) return self;
    
    NSString *substring = @"";
    for (int i = 1; i <= [self length]; i++) {
        substring = [self substringToIndex:i];
        CGFloat subwidth = [substring sizeWithAttributes:@{NSFontAttributeName:font}].width;
        if (subwidth > maxWidth) {
            substring = [NSString stringWithFormat:@"%@...", [self substringToIndex:i - 1]];
            return substring;
        }
    }
    return self;
}

- (NSString *)trim_emoji {
    NSMutableArray *emojiArray = [NSMutableArray array];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        if ([substring containsEmoji]) {
            [emojiArray addObject:substring];
        }
    }];
    NSString *newstr = [[NSString alloc] initWithString:self];
    for (NSString *emoji in emojiArray) {
        newstr = [newstr stringByReplacingOccurrencesOfString:emoji withString:@""];
    }
    return newstr;
}

- (NSString *)trim_whitespaceAndNewline {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trim_whitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trim_space {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)ggj_trim:(NSString *)string {
    if (self.length == 0 || string.length == 0) return self;
    return [self stringByReplacingOccurrencesOfString:string withString:@""];
}

- (NSString *)appendSpaceToHead:(CGFloat)width {
    if (self.length == 0) return @"";
    
    NSMutableString *mutableStr = [NSMutableString stringWithString:@""];
    CGFloat textWidth = 0.0;
    while (textWidth < width) {
        textWidth = [mutableStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}].width;
        [mutableStr appendString:@" "];
    }
    [mutableStr appendString:self];
    return mutableStr;
}

@end
