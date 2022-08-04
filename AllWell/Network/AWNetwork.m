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

const static NSString *baseURL = @"https://api.sograce.ltd:8443/api";

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
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if (AWDataHelper.shared.user && AWDataHelper.shared.user.AccessToken.length) {
        [headers setObject:AWDataHelper.shared.user.AccessToken forKey:@"token"];
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
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if (AWDataHelper.shared.user && AWDataHelper.shared.user.AccessToken.length) {
        [headers setObject:AWDataHelper.shared.user.AccessToken forKey:@"Token"];
        [headers setObject:@"212" forKey:@"AppId"];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSURLSessionDataTask *dataTask = [manager POST:[self getUrl:URLString] parameters:parameters headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponse:responseObject success:success failure:failure];
           
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

- (void) handleResponse:(NSDictionary *)responseObject success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void (^)(NSString *error))failure {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSInteger code = [[responseObject objectForKey:@"State"] intValue];
        NSString *message = [responseObject objectForKey:@"Message"];
        if (code == 0) {
            if (success) {
                success(responseObject);
            }
        } else {
            if (failure) {
                failure(message);
            }
        }
    }
}

@end
