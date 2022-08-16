//
//  AWProfileViewController.m
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/16.
//

#import "AWProfileViewController.h"
#import "UIColor+RGBA.h"
#import "AWNetwork.h"
#import "AWUserModel.h"
#import "AWDataHelper.h"
#import "AWUserInfoModel.h"

@interface AWProfileViewController ()
@property (nonatomic, weak)IBOutlet UIView *profileView;
@property (nonatomic, weak)IBOutlet UIButton *logoutButton;
@property (nonatomic, weak)IBOutlet UILabel *nameLabel;
@property (nonatomic, weak)IBOutlet UILabel *emailLabel;
@end

@implementation AWProfileViewController

+ (instancetype)viewController {
    AWProfileViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"profile"];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
    self.profileView.backgroundColor = [UIColor colorWithRGB:0xF8F8F8];
    [self.logoutButton setBackgroundColor:[UIColor colorWithRGB:0x3385FF]];
    self.profileView.layer.cornerRadius = 6.0;
    self.logoutButton.layer.cornerRadius = 20;
    [self.logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self getUserInfo];
    // Do any additional setup after loading the view.
}

- (IBAction)logoutAction:(id)sender {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[AWDataHelper shared].user.Item.UserId forKey:@"UserId"];
    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:@"en" forKey:@"Language"];
    [dict setObject:@0 forKey:@"TimeOffset"];
    [[AWNetwork sharedInstance] POST:@"/User/Logout" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        [AWDataHelper shared].user = nil;
        [AWDataHelper shared].device = nil;
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
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
        NSInteger code = [[responseObject objectForKey:@"State"] intValue];
        NSDictionary *userInfo = [responseObject objectForKey:@"UserInfo"];
        if (code == 0) {
            AWUserInfoModel *model = [AWUserInfoModel yy_modelWithDictionary:userInfo];
            self.nameLabel.text = model.Username;
            self.emailLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)model.Steps];
        }
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

@end
