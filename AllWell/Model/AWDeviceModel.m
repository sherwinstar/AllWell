//
//  AWDeviceModel.m
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/5.
//

#import "AWDeviceModel.h"

@implementation AWDeviceModel

@end

@implementation AWDeviceListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"Items" : [AWDeviceModel class]};
}
@end
