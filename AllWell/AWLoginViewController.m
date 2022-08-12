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
@property (nonatomic, weak)IBOutlet UITextField *nameField;
@property (nonatomic, weak)IBOutlet UITextField *pwdField;
@end

@implementation AWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginView.backgroundColor = [UIColor colorWithRGB:0xF8F8F8];
    [self.loginButton setBackgroundColor:[UIColor colorWithRGB:0x3385FF]];
    self.loginView.layer.cornerRadius = 6.0;
    self.loginButton.layer.cornerRadius = 20;
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (IBAction)loginAction:(id)sender {
    NSString *username = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.pwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (username.length == 0 || password.length == 0) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:username forKey:@"Name"];
    [dict setObject:password forKey:@"Pass"];
    [dict setObject:@"212" forKey:@"AppId"];
    [[AWNetwork sharedInstance] POST:@"/User/Login" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        [AWDataHelper shared].user = [AWUserModel yy_modelWithDictionary:responseObject];
        [AWDataHelper shared].shouldAddDevice = [AWDataHelper shared].user.Item.DeviceCount == 0;
//        [self getDeviceList];
//        [self getUserInfo];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)registerAction:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"register"];
    [self.navigationController pushViewController:controller animated:YES];
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

@end
