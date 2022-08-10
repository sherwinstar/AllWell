//
//  AWRegisterViewController.m
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/10.
//

#import "AWRegisterViewController.h"
#import "UIColor+RGBA.h"
#import "AWNetwork.h"
#import "AWUserModel.h"
#import "AWDataHelper.h"
#import "AWDeviceModel.h"

@interface AWRegisterViewController ()

@end

@implementation AWRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create Account";
    // Do any additional setup after loading the view.
    
}

- (IBAction)registerAction:(id)sender {
    NSString *Username;
    NSString *Email;
    NSString *Password;
    NSString *SmsCode;
    NSString *Language;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:Username forKey:@"Username"];
    [dict setObject:Email forKey:@"Email"];
    [dict setObject:Password forKey:@"Password"];
    [dict setObject:Email forKey:@"LoginName"];
    [dict setObject:Language forKey:@"Language"];
    [dict setObject:SmsCode forKey:@"SmsCode"];
    [dict setObject:@(0) forKey:@"TimeOffset"];
    
    [[AWNetwork sharedInstance] POST:@"User/RegisterEmail" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        [AWDataHelper shared].user = [AWUserModel yy_modelWithDictionary:responseObject];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)sendCodeAction:(id)sender {
    NSString *email;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:email forKey:@"Username"];
    [dict setObject:email forKey:@"Email"];
    [dict setObject:email forKey:@"LoginName"];
    [dict setObject:@"en" forKey:@"Language"];
    [dict setObject:@(1) forKey:@"CodeType"];
    [dict setObject:@(0) forKey:@"TimeOffset"];
    
    [[AWNetwork sharedInstance] POST:@"User/SendCodeForEmail" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        [AWDataHelper shared].user = [AWUserModel yy_modelWithDictionary:responseObject];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
