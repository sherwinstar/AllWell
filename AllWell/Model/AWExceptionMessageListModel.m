//
//  AWExceptionMessageListModel.m
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/12.
//

#import "AWExceptionMessageListModel.h"

@implementation AWExceptionMessageModel

@end

@implementation AWExceptionMessageListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"Items" : [AWExceptionMessageModel class]};
}

@end
