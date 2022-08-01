//
//  AWGeneralMacro.h
//
//  Created by szhou on 2019/4/11.
//  Copyright © 2019 xiaojian. All rights reserved.
//

#ifndef AWGeneralMacro_h
#define AWGeneralMacro_h

//校验block是否为空并执行
#define SafeBlockRun(block,...) if(block){block(__VA_ARGS__);};

#define HCNotificationLoginChanged @"HCNotificationLoginChanged"

//判断字符串是否为空
#define isEmptyString(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1)
//判断数组是否为空
#define isEmptyArray(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//判断字典是否为空
#define isEmptyDict(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys.count == 0)

//弱引用和强引用
#define WEAK_REF(obj) __weak __typeof__(obj) weak_##obj = obj
#define STRONG_REF(obj) __strong __typeof__(obj) strong_##obj = obj

#define isIPhoneXSeries \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define SCREEN_WIDTH_IPHONE6  375.0f
#define SCREEN_HEIGHT_IPHONE6 667.0f

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define SCREEN_SCALE     [UIScreen mainScreen].scale

#define STATUSBAR_HEIGHT     (isIPhoneXSeries ? 44 : 20)
#define NAVIGATIONBAR_HEIGHT (STATUSBAR_HEIGHT + 44)

#define IPHONEX_SAFEAREA          (isIPhoneXSeries ? 34 : 0)
#define IPHONEX_SAFEAREA_KEYBOARD (isIPhoneXSeries ? 60 : 0)

/*
 更好看的强弱引用转换
 
 ```objc
 ...
 WEAK_REF(item);
 item.someBlock = ^() {
    STRONG_REF(item);
    [item foo];
    ...
 };
 ```
 */

#define WS WEAK_REF(self);
//#define SS __strong __typeof__(weak_self) self = weak_self;
#define SS \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong __typeof__(weak_self) self = weak_self; \
_Pragma("clang diagnostic pop")

#ifndef singleton
#define singleton(c, s) objc(c, s) \
+ (instancetype)sharedInstance;
#endif

#ifndef extension
#define extension(c, e) interface c (GPREFIX##e)
#endif

#ifndef G_SEMAPHORE_LOCK
#define G_SEMAPHORE_LOCK(sem, stuff) do { \
dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER); \
stuff \
dispatch_semaphore_signal(sem); \
}while(0)
#endif

#endif /* GSGeneralMacro_h */
