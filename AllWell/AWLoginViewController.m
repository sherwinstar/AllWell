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
    [dict setObject:@"allwellapp" forKey:@"Name"];
    [dict setObject:@"123456" forKey:@"Pass"];
    [dict setObject:@"212" forKey:@"AppId"];
    [[AWNetwork sharedInstance] POST:@"/User/Login" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        [AWDataHelper shared].user = [AWUserModel yy_modelWithDictionary:responseObject];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
}

@end
