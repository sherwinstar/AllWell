//
//  HCNetwork.m
//  HIPC
//
//  Created by Shaolin Zhou on 2022/4/20.
//

#import "AWNetwork.h"
#import "AWDataHelper.h"
#import "AWGeneralMacro.h"

#define kTokenError -10000011

const static NSString *baseURL = @"http://test2api.hipcapi.com";

@implementation AWNetwork

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void (^)(NSString *error))failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:@"ios" forKey:@"platform"];
    [dict setObject:@"hipc" forKey:@"app"];
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if (AWDataHelper.shared.user && AWDataHelper.shared.user.token.length) {
        NSString *userId = [NSString stringWithFormat:@"%lu", (unsigned long)AWDataHelper.shared.user.user_id];
        [headers setObject:AWDataHelper.shared.user.token forKey:@"token"];
        [headers setObject:userId forKey:@"user-id"];
        [headers setObject:AWDataHelper.shared.user.token_type forKey:@"token-type"];
        [headers setObject:@"ios" forKey:@"platform"];
        [headers setObject:AWDataHelper.shared.user.app forKey:@"app"];
    } else {
        [headers setObject:@"ios" forKey:@"platform"];
        [headers setObject:@"hipc" forKey:@"app"];
    }
    
    NSURLSessionDataTask *dataTask = [[AFHTTPSessionManager manager] GET:[self getUrl:URLString] parameters:dict headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponse:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error.description);
        }
    }];
    
    [dataTask resume];
    return dataTask;
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(nullable id)parameters success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void (^)(NSString *error))failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:@"ios" forKey:@"platform"];
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if (AWDataHelper.shared.user && AWDataHelper.shared.user.token.length) {
        NSString *userId = [NSString stringWithFormat:@"%lu", (unsigned long)AWDataHelper.shared.user.user_id];
        [headers setObject:AWDataHelper.shared.user.token forKey:@"token"];
        [headers setObject:@"ios" forKey:@"platform"];
        [headers setObject:AWDataHelper.shared.user.app forKey:@"app"];
        [headers setObject:userId forKey:@"user-id"];
        [headers setObject:AWDataHelper.shared.user.token_type forKey:@"token-type"];
    }
    NSURLSessionDataTask *dataTask = [[AFHTTPSessionManager manager] POST:[self getUrl:URLString] parameters:dict headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponse:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error.description);
        }
    }];
    
    [dataTask resume];
    return dataTask;
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(nullable id)parameters successWithCode:(nullable void (^)(id _Nullable responseObject, NSInteger code))success failure:(nullable void (^)(NSString *error))failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:@"ios" forKey:@"platform"];
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if (AWDataHelper.shared.user && AWDataHelper.shared.user.token.length) {
        NSString *userId = [NSString stringWithFormat:@"%lu", (unsigned long)AWDataHelper.shared.user.user_id];
        [headers setObject:AWDataHelper.shared.user.token forKey:@"token"];
        [headers setObject:@"ios" forKey:@"platform"];
        [headers setObject:AWDataHelper.shared.user.app forKey:@"app"];
        [headers setObject:userId forKey:@"user-id"];
        [headers setObject:AWDataHelper.shared.user.token_type forKey:@"token-type"];
    }
    NSURLSessionDataTask *dataTask = [[AFHTTPSessionManager manager] POST:[self getUrl:URLString] parameters:dict headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponse:responseObject successWithCode:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error.description);
        }
    }];
    
    [dataTask resume];
    return dataTask;
}

- (NSString *)getUrl:(NSString *)url {
    if (url.length) {
        return [NSString stringWithFormat:@"%@/%@", baseURL, url];
    } else {
        return (NSString *)baseURL;
    }
}

- (void) handleResponse:(NSDictionary *)responseObject successWithCode:(nullable void (^)(id _Nullable responseObject, NSInteger code))success failure:(nullable void (^)(NSString *error))failure {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSInteger code = [[responseObject objectForKey:@"code"] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        NSDictionary* data = [responseObject objectForKey:@"data"];
        if (success) {
            success(data, code);
        } else {
            if (failure) {
                failure(message);
            }
        }
    }
}

- (void) handleResponse:(NSDictionary *)responseObject success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void (^)(NSString *error))failure {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSInteger code = [[responseObject objectForKey:@"code"] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        NSDictionary* data = [responseObject objectForKey:@"data"];
        if (code == 100) {
            if (success) {
                success(data);
            }
        } else if (code == kTokenError) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:HCNotificationLoginStatusChanged object:nil];
            
            if (failure) {
                failure(nil);
            }
        } else {
            if (failure) {
                failure(message);
            }
        }
    }
}

@end
