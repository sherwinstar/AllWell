//
//  ViewController.m
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/1.
//

#import "AWMainViewController.h"
#import "AWDataHelper.h"
#import "AWLoginViewController.h"
#import "UIColor+RGBA.h"
#import "AWNetwork.h"
#import "AWUserModel.h"
#import "AWDataHelper.h"
#import "AWDeviceModel.h"

@interface AWMainViewController ()
@property(nonatomic, assign)BOOL enteredAddDevice;
@property(nonatomic, strong)NSDateFormatter *dateFormatter;
@end

@implementation AWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.enteredAddDevice = NO;
    if (![[AWDataHelper shared] hasLogined]) {
        UIViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
        loginController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:loginController animated:NO completion:nil];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"My watches" style:UIBarButtonItemStyleDone target:self action:@selector(viewWatches:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[AWDataHelper shared] hasLogined] && [AWDataHelper shared].user.Item.DeviceCount == 0 && [AWDataHelper shared].shouldAddDevice && ![AWDataHelper shared].device) {
        [AWDataHelper shared].shouldAddDevice = NO;
        [self goAddDevice];
    }
    
    if ([[AWDataHelper shared] hasLogined] && [AWDataHelper shared].device) {
        [self getDailyHealthData];
    }
}

- (void)goAddDevice {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"addDevice"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewWatches:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"deviceList"];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)getDailyHealthData {
    if ([AWDataHelper shared].device == nil) {
        return;
    }
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[AWDataHelper shared].device.SerialNumber forKey:@"Imei"];
    [dict setObject:@"212" forKey:@"AppId"];
    NSString *today = [self.dateFormatter stringFromDate:[NSDate date]];
    NSString *startDate = [NSString stringWithFormat:@"%@ 00:00:00", today];
    NSString *endDate = [NSString stringWithFormat:@"%@ 23:59:59", today];
    [dict setObject:startDate forKey:@"StartDate"];
    [dict setObject:endDate forKey:@"EndDate"];
    
    [dict setObject:[AWDataHelper shared].device.Id forKey:@"DeviceId"];
    [dict setObject:@"en" forKey:@"Language"];
    [dict setObject:@0 forKey:@"TimeOffset"];
    [[AWNetwork sharedInstance] POST:@"Health/GetStepsForDay" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

@end
