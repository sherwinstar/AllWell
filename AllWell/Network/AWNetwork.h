//
//  HCNetwork.h
//  HIPC
//
//  Created by Shaolin Zhou on 2022/4/20.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWNetwork : NSObject

+ (instancetype)sharedInstance;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void (^)(NSString *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void (^)(NSString *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(nullable id)parameters successWithCode:(nullable void (^)(id _Nullable responseObject, NSInteger code))success failure:(nullable void (^)(NSString *error))failure;
@end

NS_ASSUME_NONNULL_END
