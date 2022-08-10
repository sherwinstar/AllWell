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
@property (nonatomic, weak)IBOutlet UIButton *registerButton;
@property (nonatomic, weak)IBOutlet UIButton *loginButton;
@end

@implementation AWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGB:0xF6F6F6];
    [self.loginButton setBackgroundColor:[UIColor colorWithRGB:0x3385FF]];
    self.loginView.layer.cornerRadius = 6.0;
    self.loginButton.layer.cornerRadius = 20;
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
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

- (IBAction)registerAction:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"register"];
    [self.navigationController pushViewController:controller animated:YES];
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
            [self checkDevice:@"865513041163079"];
        } else {
            AWDeviceListModel * model = [AWDeviceListModel yy_modelWithDictionary:responseObject];
            if (model.Items.count) {
                [AWDataHelper shared].device = model.Items.firstObject;
            }
            [self getDailyHealthData];
        }
        
        
    } failure:^(NSString * _Nonnull error) {
    }];
}

- (void)getUserInfo {
//    {
//        State = 0;
//        ThirdParty =     {
//            ThirdType = 0;
//            UserID = 0;
//        };
//        UserInfo =     {
//            Address = "";
//            Avatar = "";
//            Calorie = 0;
//            Distance = 0;
//            Email = "nick@miwitrack.com";
//            Gender = 0;
//            Height = 0;
//            LoginName = "nick@miwitrack.com";
//            SportTime = 0;
//            Steps = 0;
//            UserAge = 0;
//            UserId = 1548;
//            Username = "nick@miwitrack.com";
//            Weight = 0;
//        };
//    }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[AWDataHelper shared].user.Item.UserId forKey:@"UserId"];
    [dict setObject:@"212" forKey:@"AppId"];
    [[AWNetwork sharedInstance] POST:@"User/UserInfo" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        int a = 0;
        a++;
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

//- (IBAction)registerUser:(id)sender {
//    NSMutableDictionary *dict = [NSMutableDictionary new];
//    [dict setObject:@"212" forKey:@"AppId"];
//    [dict setObject:@"shuishou" forKey:@"MobilePhone"];
//
//    
//    [[AWNetwork sharedInstance] POST:@"User/CustomRegister" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
//        [AWDataHelper shared].user = [AWUserModel yy_modelWithDictionary:responseObject];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        
//    } failure:^(NSString * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
//}

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
        [self checkDevice:@"865513041163079"];
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)checkDevice:(NSString *)serialNumber {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:serialNumber forKey:@"SerialNumber"];
    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:[AWDataHelper shared].user.Item.UserId forKey:@"UserId"];
    [dict setObject:@"zh-cn" forKey:@"Language"];
    [dict setObject:@8 forKey:@"TimeOffset"];
    [[AWNetwork sharedInstance] POST:@"Device/CheckDevice" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        int a = 0;
        a++;
        NSString *phone = [AWDataHelper shared].user.Item.Username;
        [self addDevice:serialNumber deviceId:146 relation:@"父子" deviceType:2 phone:phone];
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)addDevice:(NSString *)serialNumber deviceId:(NSInteger)deviceId relation:(NSString *)relation deviceType:(NSUInteger)type phone:(NSString *)phone{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@(deviceId) forKey:@"DeviceId"];
    [dict setObject:@(type) forKey:@"DeviceType"];
    [dict setObject:relation forKey:@"RelationName"];
    [dict setObject:phone forKey:@"RelationPhone"];
    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:[AWDataHelper shared].user.Item.UserId forKey:@"UserId"];
    [dict setObject:@"zh-cn" forKey:@"Language"];
    [dict setObject:@8 forKey:@"TimeOffset"];
    [[AWNetwork sharedInstance] POST:@"Device/AddDeviceAndUserGroup" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        int a = 0;
        a++;
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

@end
