//
//  AWStepsForDayModel.h
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//        Distance = "0.01";
//        Items =     (
//                    {
//                Cariello = "0.87";
//                Date = "2022-08-12";
//                Distance = "0.01";
//                Steps = 19;
//            }
//        );
//        State = 0;
//        Step = 19;

@interface AWDailyStepsModel : NSObject
@property (nonatomic, copy) NSString *Date;
@property (nonatomic, copy) NSString *Cariello;
@property (nonatomic, copy) NSString *Distance;
@property (nonatomic, assign) NSUInteger Steps;
@end

@interface AWStepsForDayModel : NSObject
@property (nonatomic, strong) NSMutableArray *Items;
@property (nonatomic, copy) NSString *Distance;
@property (nonatomic, assign) NSUInteger Step;
@end

NS_ASSUME_NONNULL_END
