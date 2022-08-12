//
//  AWStepsForDayModel.m
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/12.
//

#import "AWStepsForDayModel.h"

@implementation AWDailyStepsModel

@end

@implementation AWStepsForDayModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"Items" : [AWDailyStepsModel class]};
}
@end
