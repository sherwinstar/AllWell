//
//  UIColor+RGBA.h
//
//  Created by Hale Chan on 8/6/15.
//

#import <UIKit/UIKit.h>

/**
 *  基于RGBA的UIColor扩展方法集
 */
@interface UIColor (RGBA)

/**
 *  由一个整数生成颜色
 *
 *  @param argb argb信息，每8位表示一个颜色通道
 *
 *  @return 一个UIColor实例
 */
+ (UIColor *)colorWithARGB:(uint32_t)argb;

/**
 *  由一个整数生成颜色
 *
 *  @param rgba rgba信息，每8位表示一个颜色通道
 *
 *  @return 一个UIColor实例
 */
+ (UIColor *)colorWithRGBA:(uint32_t)rgba;

/**
 *  由一个整数生成颜色
 *
 *  @param rgb rgb信息，每8位表示一个颜色通道
 *
 *  @return 一个UIColor实例
 */
+ (UIColor *)colorWithRGB:(uint32_t)rgb;

/**
 *  由一个整数及alpha值生成颜色
 *
 *  @param rgb   rgb信息，每8位表示一个颜色通道
 *  @param alpha alpha值
 *
 *  @return 一个UIColor实例
 */
+ (UIColor *)colorWithRGB:(uint32_t)rgb alpha:(CGFloat)alpha;

/**
 *  由一个WEB颜色串生成一个UIColor
 *
 *  @param hexString web颜色串，支持形式有："#rrggbbaa"、"#rrggbb"、"#rgb"、"rrggbbaa"、"rrggbb"、"rgb"
 *
 *  @return 一个UIColor实例
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  生成WEB颜色串
 *
 *  @return 返回一个"#rrggbbaa"串
 */
- (NSString *)RGBAHexString;

/**
 *  生成WEB颜色串
 *
 *  @return 返回一个"#aarrggbb"串
 */
- (NSString *)ARGBHexString;

/**
 *  生成WEB颜色串
 *
 *  @return 返回一个"#rrggbb"串
 */
- (NSString *)RGBHexString;

/**
 *  获取一个过渡色
 */
+ (UIColor *)colorFrom:(UIColor *)fromColor to:(UIColor *)toColor progress:(CGFloat)progress ignoreAlpha:(BOOL)ignoreAlpha;

/**
*  生成WEB颜色值
*
*  @param hexString web颜色串，支持形式有："#rrggbbaa"、"#rrggbb"、"#rgb"、"rrggbbaa"、"rrggbb"、"rgb"
*
*  @return 返回一个uint32_t色值
*/
+ (uint32_t)hexFromHexString:(NSString *)hexString;

- (UIImage*)colorToImage;

@end

static inline NSString *RGBAFromARBG(NSString *argb) {
    NSString *pureARGB = [argb hasPrefix:@"#"] ? [argb substringFromIndex:1] : argb;
    const NSInteger length = pureARGB.length;
    if (4 == length) {
        return [[pureARGB substringFromIndex:1] stringByAppendingString:[pureARGB substringToIndex:1]];
    } else if(8 == length) {
        return [[pureARGB substringFromIndex:2] stringByAppendingString:[pureARGB substringToIndex:2]];
    }
    
    return argb;
}
