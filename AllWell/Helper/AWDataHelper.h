//
//  HCUserInfo.h
//  HIPC
//
//  Created by Shaolin Zhou on 2022/5/4.
//

#import <Foundation/Foundation.h>
#import "AWUserModel.h"
#import "AWDeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AWDataHelper : NSObject

@property(nonatomic, strong, nullable) AWUserModel *user;
@property(nonatomic, strong, nullable) AWDeviceModel *device;

+ (instancetype)shared;
- (BOOL)hasLogined;
- (void)logout;

@end

NS_ASSUME_NONNULL_END
