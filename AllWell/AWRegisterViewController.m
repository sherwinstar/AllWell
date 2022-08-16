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
@property (nonatomic, weak)IBOutlet UIView *registerView;
@property (nonatomic, weak)IBOutlet UIButton *registerButton;
@property (nonatomic, weak)IBOutlet UITextField *nameField;
@property (nonatomic, weak)IBOutlet UITextField *pwdField;
@property (nonatomic, weak)IBOutlet UITextField *emailField;
@property (nonatomic, weak)IBOutlet UITextField *codeField;
@end

@implementation AWRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create Account";
    self.view.backgroundColor = [UIColor colorWithRGB:0xF6F6F6];
    [self.registerButton setBackgroundColor:[UIColor colorWithRGB:0x3385FF]];
    self.registerView.layer.cornerRadius = 6.0;
    self.registerButton.layer.cornerRadius = 20;
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissTap:)];
    [self.view addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view.
}

- (void)dissTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)registerAction:(id)sender {
    NSString *username = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.pwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *smsCode = [self.codeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (username.length == 0 || email.length == 0 || password.length == 0 || smsCode.length == 0) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:username forKey:@"Username"];
    [dict setObject:email forKey:@"Email"];
    [dict setObject:password forKey:@"Password"];
    [dict setObject:email forKey:@"LoginName"];
    [dict setObject:@"en" forKey:@"Language"];
    [dict setObject:smsCode forKey:@"SmsCode"];
    [dict setObject:@(0) forKey:@"TimeOffset"];
    
    [[AWNetwork sharedInstance] POST:@"User/RegisterEmail" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        NSInteger code = [[responseObject objectForKey:@"State"] integerValue];
        if (code == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)sendCodeAction:(id)sender {
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (email.length == 0) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:email forKey:@"Username"];
    [dict setObject:email forKey:@"Email"];
    [dict setObject:email forKey:@"LoginName"];
    [dict setObject:@"en" forKey:@"Language"];
    [dict setObject:@(1) forKey:@"CodeType"];
    [dict setObject:@(0) forKey:@"TimeOffset"];
    
    [[AWNetwork sharedInstance] POST:@"User/SendCodeForEmail" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        NSInteger code = [[responseObject objectForKey:@"State"] integerValue];
        if (code == 0) {
            
        }
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
