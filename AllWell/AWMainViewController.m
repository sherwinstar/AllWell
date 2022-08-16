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
#import "AWExceptionMessageListModel.h"
#import <Toast/UIView+Toast.h>
#import "AWProfileViewController.h"

@interface AWMainViewController ()
@property(nonatomic, strong)NSDateFormatter *dateFormatter;
@property(nonatomic, strong)AWDailyStepsModel *dailyStepsModel;
@property(nonatomic, strong)AWExceptionMessageModel *fallDownModel;
@property (nonatomic, weak)IBOutlet UITableView *infoTableView;
@property (nonatomic, weak)IBOutlet UIButton *takePhotoButton;
@property (nonatomic, weak)IBOutlet UIButton *callButton;

@end

@implementation AWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Information";
    [self.takePhotoButton setBackgroundColor:[UIColor colorWithRGB:0x3385FF]];
    self.takePhotoButton.layer.cornerRadius = 20;
    [self.takePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.callButton setBackgroundColor:[UIColor colorWithRGB:0x3385FF]];
    self.callButton.layer.cornerRadius = 20;
    [self.callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"My Watches" style:UIBarButtonItemStyleDone target:self action:@selector(viewWatches:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStyleDone target:self action:@selector(viewProfile:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[AWDataHelper shared] hasLogined]) {
        UIViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
        loginController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:loginController animated:NO completion:nil];
        return;
    }
    if ([AWDataHelper shared].user.Item.DeviceCount == 0 && [AWDataHelper shared].shouldAddDevice && ![AWDataHelper shared].device) {
        [AWDataHelper shared].shouldAddDevice = NO;
        [self goAddDevice];
        return;
    } else if ([AWDataHelper shared].user.Item.DeviceCount > 0 && ![AWDataHelper shared].device) {
        [self getDeviceList];
    } else if ([AWDataHelper shared].device) {
        [self getDailyHealthData];
        [self getExceptionList];
    } else if ([AWDataHelper shared].shouldAddDevice == NO) {
        [self getDeviceList];
    }
}

- (void)viewProfile:(id)sender {
    AWProfileViewController *controller = [AWProfileViewController viewController];
    [self.navigationController pushViewController:controller animated:YES];
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
    return 2;
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
    if (indexPath.row == 0) {
        if (self.dailyStepsModel) {
            dateLabel.text = self.dailyStepsModel.Date;
            calloriLabel.text = [NSString stringWithFormat:@"Cariello: %@", self.dailyStepsModel.Cariello];
            distanceLabel.text = [NSString stringWithFormat:@"Distance: %@", self.dailyStepsModel.Distance];
            stepsLabel.text = [NSString stringWithFormat:@"Steps: %lu", (unsigned long)self.dailyStepsModel.Steps];
        } else {
            dateLabel.text = @"No Activity Data";
            calloriLabel.text = @"";
            distanceLabel.text = @"";
            stepsLabel.text = @"";
        }
    } else if (indexPath.row == 1) {
        if (self.fallDownModel) {
            dateLabel.text = @"Fall Down Alert";
            calloriLabel.text = self.fallDownModel.SerialNumber;
            distanceLabel.text = self.fallDownModel.ExceptionName;
            stepsLabel.text = self.fallDownModel.Message;
        } else {
            dateLabel.text = @"No Fall Down Alert";
            calloriLabel.text = @"";
            distanceLabel.text = @"";
            stepsLabel.text = @"";
        }
    }
    
    return cell;
}

- (void)getDeviceList {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[AWDataHelper shared].user.Item.UserId forKey:@"UserId"];
//    [dict setObject:@"123456" forKey:@"Pass"];
    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:@"Google" forKey:@"MapType"];
    [dict setObject:@1 forKey:@"GroupId"];
    [dict setObject:@"en" forKey:@"Language"];
    [dict setObject:@0 forKey:@"TimeOffset"];

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
                [self getExceptionList];
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

//获取报警信息ExceptionMessage/ExcdeptionListWhitoutCode
//入口参数    {"Id":1548,"PageNo":1,"PageCount":10,"TypeID":0,"MapType":"google","DataCode":null,"UserID":0,"Exclude":null,"Language":"zh-cn","TimeOffset":8.0,"AppId":"188"}


- (void)getExceptionList {
    if ([AWDataHelper shared].device == nil) {
        return;
    }
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];

    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:@1 forKey:@"PageNo"];
    [dict setObject:@10 forKey:@"PageCount"];
    [dict setObject:@"Google" forKey:@"MapType"];
    [dict setObject:[AWDataHelper shared].device.Id forKey:@"DeviceId"];
    [dict setObject:[AWDataHelper shared].user.Item.UserId forKey:@"Id"];
    [dict setObject:@"en" forKey:@"Language"];
    [dict setObject:@0 forKey:@"TimeOffset"];
    [[AWNetwork sharedInstance] POST:@"ExceptionMessage/ExcdeptionListWhitoutCode" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        NSInteger code = [[responseObject objectForKey:@"State"] intValue];
        if (code == 0) {
            AWExceptionMessageListModel *model = [AWExceptionMessageListModel yy_modelWithDictionary:responseObject];
            for (AWExceptionMessageModel *ec in model.Items) {
                if (ec.NotificationType == 110) {
                    self.fallDownModel = ec;
                    [self.infoTableView reloadData];
                    break;
                }
            }
        }
        if (!self.fallDownModel) {
            [self.view makeToast:@"No fall down alert" duration:2.0 position:CSToastPositionCenter];
        }
        
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)callAction:(id)sender {
    if ([AWDataHelper shared].device == nil) {
        return;
    }
    if ([AWDataHelper shared].device.Sim.length == 0) {
        [self.view makeToast:@"Please fill the sim of watch" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    NSString * phone = [NSString stringWithFormat:@"telprompt://%@",[AWDataHelper shared].device.Sim];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:nil];
}

- (IBAction)sendTakePhotoCmd:(id)sender {
    if ([AWDataHelper shared].device == nil) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary new];

    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:@1 forKey:@"IsNewCmdFormat"];
    [dict setObject:@([AWDataHelper shared].device.Model) forKey:@"DeviceModel"];
    [dict setObject:@"0031" forKey:@"CmdCode"];
    [dict setObject:[AWDataHelper shared].device.Id forKey:@"DeviceId"];
    [dict setObject:[AWDataHelper shared].user.Item.UserId forKey:@"Id"];
    [dict setObject:@"en" forKey:@"Language"];
    [dict setObject:@0 forKey:@"TimeOffset"];
    [[AWNetwork sharedInstance] POST:@"Command/SendCommand" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        NSInteger code = [[responseObject objectForKey:@"State"] intValue];
        if (code == 0) {
            [self.view makeToast:@"Successful to send cmd to take photo" duration:2.0 position:CSToastPositionCenter];
        }
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

@end
