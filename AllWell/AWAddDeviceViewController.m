//
//  AWAddDeviceViewController.m
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/9.
//

#import "AWAddDeviceViewController.h"
#import "UIColor+RGBA.h"
#import "AWNetwork.h"
#import "AWUserModel.h"
#import "AWDataHelper.h"
#import "AWDeviceModel.h"

@interface AWAddDeviceViewController ()
@property (nonatomic, weak)IBOutlet UIView *addView;
@property (nonatomic, weak)IBOutlet UIButton *bindButton;
@property (nonatomic, weak)IBOutlet UITextField *nameField;
@property (nonatomic, weak)IBOutlet UITextField *imeiField;
@end

@implementation AWAddDeviceViewController

+ (instancetype)viewController {
    AWAddDeviceViewController *devicesController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addDevice"];
    return devicesController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add device";
    self.view.backgroundColor = [UIColor colorWithRGB:0xF6F6F6];
    [self.bindButton setBackgroundColor:[UIColor colorWithRGB:0x3385FF]];
    self.addView.layer.cornerRadius = 6.0;
    self.bindButton.layer.cornerRadius = 20;
    [self.bindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (IBAction)bindAction:(id)sender {
    NSString *name = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *imei = [self.imeiField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (name.length == 0 || imei.length == 0) {
        return;
    }
    [self checkDevice:imei name:name];
}

- (void)checkDevice:(NSString *)serialNumber name:(NSString *)name {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:serialNumber forKey:@"SerialNumber"];
    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:[AWDataHelper shared].user.Item.UserId forKey:@"UserId"];
    [dict setObject:@"en" forKey:@"Language"];
    [dict setObject:@0 forKey:@"TimeOffset"];
    [[AWNetwork sharedInstance] POST:@"Device/CheckDevice" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        NSInteger code = [[responseObject objectForKey:@"State"] intValue];
        if (code == 0) {
            NSString *phone = [AWDataHelper shared].user.Item.Username;
            NSInteger deviceId = [[responseObject objectForKey:@"DeviceId"] integerValue];
            NSInteger deviceType = [[responseObject objectForKey:@"DeviceType"] integerValue];
            [self addDevice:serialNumber deviceId:deviceId relation:name deviceType:deviceType phone:phone];
        }
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
    [dict setObject:@"en" forKey:@"Language"];
    [dict setObject:@0 forKey:@"TimeOffset"];
    [[AWNetwork sharedInstance] POST:@"Device/AddDeviceAndUserGroup" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        NSInteger code = [[responseObject objectForKey:@"State"] intValue];
        if (code == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

@end
