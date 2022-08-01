//
//  UIColor+RGBA.m
//
//  Created by Hale Chan on 8/6/15.
//

#import "UIColor+RGBA.h"

static short hexCharToShort(char a)
{
    if (a >= '0' && a <= '9') {
        return a - '0';
    }
    else if( a>='a' && a<='f') {
        return a - 'a' + 10;
    }
    else if( a>= 'A' && a<='F') {
        return a - 'A' + 10;
    }
    else {
        return 0;
    }
}

@implementation UIColor (RGBA)

- (UIImage*)colorToImage {

    CGRect rect = CGRectMake(0,0,1,1);

    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [self CGColor]);

    CGContextFillRect(context, rect);

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return theImage;
}

+ (UIColor *)colorWithARGB:(uint32_t)argb
{
    return [UIColor colorWithRed:((argb&0xff0000)>>16)/255.0 green:((argb&0xff00)>>8)/255.0 blue:(argb&0xff)/255.0 alpha:(argb>>24)/255.0];
}

+ (UIColor *)colorWithRGB:(uint32_t)rgb
{
    return [UIColor colorWithRed:((rgb&0xff0000)>>16)/255.0 green:((rgb&0xff00)>>8)/255.0 blue:(rgb&0xff)/255.0 alpha:1.0];
}

+ (UIColor *)colorWithRGB:(uint32_t)rgb alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((rgb&0xff0000)>>16)/255.0 green:((rgb&0xff00)>>8)/255.0 blue:(rgb&0xff)/255.0 alpha:alpha];
}

+ (UIColor *)colorWithRGBA:(uint32_t)rgba
{
    return [UIColor colorWithRed:(rgba>>24)/255.0 green:((rgba&0xff0000)>>16)/255.0 blue:((rgba&0xff00)>>8)/255.0 alpha:(rgba&0xff)/255.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSString *colorString;
    if ([hexString hasPrefix:@"#"]) {
        colorString = [hexString substringFromIndex:1];
    }
    else {
        colorString = hexString;
    }
    
    CGFloat r,g,b,a;
    
    switch (colorString.length) {
        case 3:{
            r = hexCharToShort([colorString characterAtIndex:0]) / (float)0xF;
            g = hexCharToShort([colorString characterAtIndex:1]) / (float)0xF;
            b = hexCharToShort([colorString characterAtIndex:2]) / (float)0xF;
            a = 1.0;
        }
            break;
        case 4:{
            r = hexCharToShort([colorString characterAtIndex:0]) / (float)0xF;
            g = hexCharToShort([colorString characterAtIndex:1]) / (float)0xF;
            b = hexCharToShort([colorString characterAtIndex:2]) / (float)0xF;
            a = hexCharToShort([colorString characterAtIndex:3]) / (float)0xF;
        }
            break;
        case 6:{
            r = (hexCharToShort([colorString characterAtIndex:0])*0x10 + hexCharToShort([colorString characterAtIndex:1])) / (float)0xFF;
            g = (hexCharToShort([colorString characterAtIndex:2])*0x10 + hexCharToShort([colorString characterAtIndex:3])) / (float)0xFF;
            b = (hexCharToShort([colorString characterAtIndex:4])*0x10 + hexCharToShort([colorString characterAtIndex:5])) / (float)0xFF;
            a = 1.0;
        }
            break;
        case 8:{
            r = (hexCharToShort([colorString characterAtIndex:0])*0x10 + hexCharToShort([colorString characterAtIndex:1])) / (float)0xFF;
            g = (hexCharToShort([colorString characterAtIndex:2])*0x10 + hexCharToShort([colorString characterAtIndex:3])) / (float)0xFF;
            b = (hexCharToShort([colorString characterAtIndex:4])*0x10 + hexCharToShort([colorString characterAtIndex:5])) / (float)0xFF;
            a = (hexCharToShort([colorString characterAtIndex:6])*0x10 + hexCharToShort([colorString characterAtIndex:7])) / (float)0xFF;
        }
            break;
        default:
            return nil;
            break;
    }
    
    return [self colorWithRed:r green:g blue:b alpha:a];
}

- (NSString *)RGBAHexString
{
    int r,g,b,a;
    CGFloat red, green, blue, alpha;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    r = red * (float)0xff;
    g = green * (float)0xff;
    b = blue * (float)0xff;
    a = alpha * (float)0xff;
    
    return [NSString stringWithFormat:@"#%.2x%.2x%.2x%.2x", r, g, b, a];
}

- (NSString *)ARGBHexString {
    int alphaInt, redInt, greenInt, blueInt;
    CGFloat alpha, red, green, blue;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    alphaInt = alpha * (float)0xff;
    redInt = red * (float)0xff;
    greenInt = green * (float)0xff;
    blueInt = blue * (float)0xff;
    
    return [NSString stringWithFormat:@"#%.2x%.2x%.2x%.2x", alphaInt, redInt, greenInt, blueInt];
}

- (NSString *)RGBHexString
{
    int r,g,b;
    CGFloat red, green, blue, alpha;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    r = red * (float)0xff;
    g = green * (float)0xff;
    b = blue * (float)0xff;
    
    return [NSString stringWithFormat:@"#%.2x%.2x%.2x", r, g, b];
}

+ (UIColor *)colorFrom:(UIColor *)fromColor to:(UIColor *)toColor progress:(CGFloat)progress ignoreAlpha:(BOOL)ignoreAlpha
{
    NSParameterAssert(fromColor && toColor);
    if (progress <= 0) {
        return fromColor;
    }
    if (progress >= 1) {
        return toColor;
    }
    CGFloat fromRed = 0.0, fromGreen = 0.0, fromBlue = 0.0, fromAlpha = 0.0;
    CGFloat toRed = 0.0, toGreen = 0.0, toBlue = 0.0, toAlpha = 0.0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    return [[UIColor alloc] initWithRed:(fromRed + (toRed - fromRed) * progress)
                                  green:(fromGreen + (toGreen - fromGreen) * progress)
                                   blue:(fromBlue + (toBlue - fromBlue) * progress)
                                  alpha:(ignoreAlpha ? 1 : (fromAlpha + (toAlpha - fromAlpha) * progress))];
}

+ (uint32_t)hexFromHexString:(NSString *)hexString
{
    NSString *colorString;
    if ([hexString hasPrefix:@"#"]) {
        colorString = [hexString substringFromIndex:1];
    }
    else {
        colorString = hexString;
    }
    
    CGFloat r,g,b,a;
    
    switch (colorString.length) {
        case 3:{
            r = hexCharToShort([colorString characterAtIndex:0]) / (float)0xF;
            g = hexCharToShort([colorString characterAtIndex:1]) / (float)0xF;
            b = hexCharToShort([colorString characterAtIndex:2]) / (float)0xF;
            a = 1.0;
        }
            break;
        case 4:{
            r = hexCharToShort([colorString characterAtIndex:0]) / (float)0xF;
            g = hexCharToShort([colorString characterAtIndex:1]) / (float)0xF;
            b = hexCharToShort([colorString characterAtIndex:2]) / (float)0xF;
            a = hexCharToShort([colorString characterAtIndex:3]) / (float)0xF;
        }
            break;
        case 6:{
            r = (hexCharToShort([colorString characterAtIndex:0])*0x10 + hexCharToShort([colorString characterAtIndex:1])) / (float)0xFF;
            g = (hexCharToShort([colorString characterAtIndex:2])*0x10 + hexCharToShort([colorString characterAtIndex:3])) / (float)0xFF;
            b = (hexCharToShort([colorString characterAtIndex:4])*0x10 + hexCharToShort([colorString characterAtIndex:5])) / (float)0xFF;
            a = 1.0;
        }
            break;
        case 8:{
            r = (hexCharToShort([colorString characterAtIndex:0])*0x10 + hexCharToShort([colorString characterAtIndex:1])) / (float)0xFF;
            g = (hexCharToShort([colorString characterAtIndex:2])*0x10 + hexCharToShort([colorString characterAtIndex:3])) / (float)0xFF;
            b = (hexCharToShort([colorString characterAtIndex:4])*0x10 + hexCharToShort([colorString characterAtIndex:5])) / (float)0xFF;
            a = (hexCharToShort([colorString characterAtIndex:6])*0x10 + hexCharToShort([colorString characterAtIndex:7])) / (float)0xFF;
        }
            break;
        default:
            return 0x00000000;
            break;
    }
    
    return lroundf(r * 255) * pow(16, 6) + lroundf(g * 255) * pow(16, 4) + lroundf(b * 255)* pow(16, 2) + lroundf(a * 255);
}

@end
