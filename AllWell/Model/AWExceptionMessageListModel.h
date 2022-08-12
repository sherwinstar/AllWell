//
//  AWExceptionMessageListModel.h
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/12.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@interface AWExceptionMessageModel : NSObject
@property (nonatomic, copy) NSString *DeviceDate;
@property (nonatomic, copy) NSString *Nickname;
@property (nonatomic, copy) NSString *SerialNumber;
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *ExceptionName;
@property (nonatomic, copy) NSString *Message;
@property (nonatomic, copy) NSString *ModelName;
@property (nonatomic, assign) NSUInteger NotificationType;
@property (nonatomic, assign) NSUInteger Steps;
@property (nonatomic, assign) NSUInteger DeviceID;
@end

@interface AWExceptionMessageListModel : NSObject
@property (nonatomic, strong) NSMutableArray *Items;
@property (nonatomic, assign) NSUInteger Total;
@property (nonatomic, assign) NSUInteger Page;
@end

NS_ASSUME_NONNULL_END
