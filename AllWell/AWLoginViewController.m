//
//  AWLoginViewController.m
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/3.
//

#import "AWLoginViewController.h"
#import "UIColor+RGBA.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
