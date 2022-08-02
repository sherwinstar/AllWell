//
//  YCUserModel.h
//  HIPC
//
//  Created by Shaolin Zhou on 2022/5/4.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWUserModel : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) NSUInteger user_id;
@property (nonatomic, copy) NSString *app;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *token_type;
@property (nonatomic, assign) BOOL is_auth_compute;
@property (nonatomic, assign) BOOL is_bind;

@end

NS_ASSUME_NONNULL_END
