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
#import "AWStepsForDayModel.h"

@interface AWMainViewController ()
@property(nonatomic, strong)NSDateFormatter *dateFormatter;
@property(nonatomic, strong)AWDailyStepsModel *dailyStepsModel;
@property (nonatomic, weak)IBOutlet UITableView *infoTableView;
@end

@implementation AWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Information";
    self.dateFormatter = [[NSDateFormatter alloc] init];
    if (![[AWDataHelper shared] hasLogined]) {
        UIViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
        loginController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:loginController animated:NO completion:nil];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"My watches" style:UIBarButtonItemStyleDone target:self action:@selector(viewWatches:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[AWDataHelper shared] hasLogined])
        return;
    if ([AWDataHelper shared].user.Item.DeviceCount == 0 && [AWDataHelper shared].shouldAddDevice && ![AWDataHelper shared].device) {
        [AWDataHelper shared].shouldAddDevice = NO;
        [self goAddDevice];
        return;
    } else if ([AWDataHelper shared].user.Item.DeviceCount > 0 && ![AWDataHelper shared].device) {
        [self getDeviceList];
    } else if ([AWDataHelper shared].device) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dailyStepsModel ? 1 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kItemCellID = @"dailyHealthCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:kItemCellID forIndexPath:indexPath];
    UILabel *dateLabel = [cell viewWithTag:1];
    UILabel *calloriLabel = [cell viewWithTag:2];
    UILabel *distanceLabel = [cell viewWithTag:3];
    UILabel *stepsLabel = [cell viewWithTag:4];
    dateLabel.text = self.dailyStepsModel.Date;
    calloriLabel.text = [NSString stringWithFormat:@"Cariello: %@", self.dailyStepsModel.Cariello];
    distanceLabel.text = [NSString stringWithFormat:@"Distance: %@", self.dailyStepsModel.Distance];
    stepsLabel.text = [NSString stringWithFormat:@"Steps: %lu", (unsigned long)self.dailyStepsModel.Steps];
    return cell;
}

- (void)getDeviceList {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[AWDataHelper shared].user.Item.UserId forKey:@"UserId"];
//    [dict setObject:@"123456" forKey:@"Pass"];
    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:@"Google" forKey:@"MapType"];
    [dict setObject:@1 forKey:@"GroupId"];
    [dict setObject:@"zh-cn" forKey:@"Language"];
    [dict setObject:@8 forKey:@"TimeOffset"];

//    [dict setObject:@"allwellapp" forKey:@"LoginName"];
//    [dict setObject:@"10" forKey:@"GroupId"];
    [[AWNetwork sharedInstance] POST:@"Device/PersonDeviceList" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {

        NSInteger code = [[responseObject objectForKey:@"State"] intValue];
        if (code == 100) {
            //无数据无表
        } else {
            AWDeviceListModel *listModel = [AWDeviceListModel yy_modelWithDictionary:responseObject];
            if (listModel.Items.count && ![AWDataHelper shared].device) {
                [AWDataHelper shared].device = listModel.Items.firstObject;
                [self getDailyHealthData];
            }
        }
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
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
        NSInteger code = [[responseObject objectForKey:@"State"] intValue];
        if (code == 0) {
            AWStepsForDayModel *model = [AWStepsForDayModel yy_modelWithDictionary:responseObject];
            if (model.Items.count > 0) {
                self.dailyStepsModel = model.Items.firstObject;
                [self.infoTableView reloadData];
            }
        }
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

@end
