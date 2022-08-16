//
//  AWUserInfoModel.h
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWUserInfoModel : NSObject

//            Calorie = 0;
//            Distance = 0;
//            Email = "nick@miwitrack.com";
//            Gender = 0;
//            Height = 0;
//            LoginName = "nick@miwitrack.com";
//            SportTime = 0;
//            Steps = 0;
//            UserAge = 0;
//            UserId = 1548;
//            Username = "nick@miwitrack.com";

@property (nonatomic, copy) NSString *Username;
@property (nonatomic, copy) NSString *LoginName;
@property (nonatomic, copy) NSString *Email;
@property (nonatomic, assign) NSUInteger Steps;
@property (nonatomic, assign) NSUInteger Calorie;
@property (nonatomic, assign) NSUInteger Distance;
@property (nonatomic, assign) NSUInteger UserId;

@end

NS_ASSUME_NONNULL_END
