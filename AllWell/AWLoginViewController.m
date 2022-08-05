//
//  AWLoginViewController.m
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/3.
//

#import "AWLoginViewController.h"
#import "UIColor+RGBA.h"
#import "AWNetwork.h"
#import "AWUserModel.h"
#import "AWDataHelper.h"
#import "AWDeviceModel.h"

@interface AWLoginViewController ()
@property (nonatomic, weak)IBOutlet UIView *loginView;
@property (nonatomic, weak)IBOutlet UIView *registerView;
@property (nonatomic, weak)IBOutlet UIButton *switchButton;
@end

@implementation AWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGB:0xF6F6F6];
    self.loginView.layer.cornerRadius = 6.0;
    self.registerView.layer.cornerRadius = 6.0;
    self.switchButton.layer.cornerRadius = 6.0;
    self.registerView.hidden = YES;
    [self.switchButton setTitle:@"Register" forState:UIControlStateNormal];
    [self.switchButton setTitle:@"Login" forState:UIControlStateSelected];
    [self.switchButton setBackgroundColor:[UIColor colorWithRGB:0xFFFFFF]];
    // Do any additional setup after loading the view.
}

- (IBAction)switchAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.registerView.hidden = NO;
        self.loginView.hidden = YES;
    } else {
        self.registerView.hidden = YES;
        self.loginView.hidden = NO;
    }
}

- (IBAction)loginAction:(id)sender {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"nick@miwitrack.com" forKey:@"Name"];
    [dict setObject:@"123456" forKey:@"Pass"];
    [dict setObject:@"212" forKey:@"AppId"];
    [[AWNetwork sharedInstance] POST:@"/User/Login" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        [AWDataHelper shared].user = [AWUserModel yy_modelWithDictionary:responseObject];
        [self getDeviceList];
        [self getUserInfo];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
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
        AWDeviceListModel * model = [AWDeviceListModel yy_modelWithDictionary:responseObject];
        if (model.Items.count) {
            [AWDataHelper shared].device = model.Items.firstObject;
        }
        [self getDailyHealthData];
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(error);
    }];
}

- (void)getUserInfo {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[AWDataHelper shared].user.Item.UserId forKey:@"UserId"];
    [dict setObject:@"212" forKey:@"AppId"];
    [[AWNetwork sharedInstance] POST:@"User/UserInfo" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        int a = 0;
        a++;
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(error);
    }];
}

- (IBAction)registerUser:(id)sender {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:@"shuishou" forKey:@"MobilePhone"];
//    "MobilePhone": "string", (any phonenumber)
//      "ThirdId": "string",
//      "Language": "string",
//      "TimeOffset": 0,
//      "AppId": "string" (212 is given by sograce to us)

    
    [[AWNetwork sharedInstance] POST:@"User/CustomRegister" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        [AWDataHelper shared].user = [AWUserModel yy_modelWithDictionary:responseObject];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(error);
    }];
}

- (void)getDailyHealthData {
    if ([AWDataHelper shared].device == nil) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[AWDataHelper shared].device.SerialNumber forKey:@"Imei"];
    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:@"2022-08-05 00:00:00" forKey:@"StartDate"];
    [dict setObject:@"2022-08-05 23:59:59" forKey:@"EndDate"];
    
    [dict setObject:[AWDataHelper shared].device.Id forKey:@"DeviceId"];
    [dict setObject:@"zh-cn" forKey:@"Language"];
    [dict setObject:@8 forKey:@"TimeOffset"];
    [[AWNetwork sharedInstance] POST:@"Health/GetStepsForDay" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        int a = 0;
        a++;
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(error);
    }];
    
}

@end
