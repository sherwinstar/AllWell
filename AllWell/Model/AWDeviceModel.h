//
//  AWDeviceModel.h
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AWDeviceModel : NSObject
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, assign) CGFloat Latitude;
@property (nonatomic, assign) CGFloat Longitude;
@property (nonatomic, assign) CGFloat Speed;
@property (nonatomic, assign) NSUInteger Steps;
@property (nonatomic, assign) NSUInteger Battery;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, assign)NSUInteger Status;
@property (nonatomic, copy) NSString *SerialNumber;
@property (nonatomic, copy) NSString *NickName;

@end

@interface AWDeviceListModel : NSObject
@property (nonatomic, copy) NSArray *Items;
@property (nonatomic, assign) NSUInteger ExceptionCount;
@property (nonatomic, assign) NSUInteger MessageCount;

@end

NS_ASSUME_NONNULL_END
