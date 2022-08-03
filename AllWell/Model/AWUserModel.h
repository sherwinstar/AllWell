//
//  YCUserModel.h
//  HIPC
//
//  Created by Shaolin Zhou on 2022/5/4.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

NS_ASSUME_NONNULL_BEGIN


@interface AWItemModel : NSObject

@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *Username;

@end

@interface AWUserModel : NSObject

@property (nonatomic, copy) NSString *AccessToken;
@property (nonatomic, strong) AWItemModel *Item;

@end

NS_ASSUME_NONNULL_END
