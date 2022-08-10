//
//  ViewController.m
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/1.
//

#import "AWMainViewController.h"
#import "AWDataHelper.h"
#import "AWLoginViewController.h"

@interface AWMainViewController ()
@property(nonatomic, assign)BOOL enteredAddDevice;
@end

@implementation AWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enteredAddDevice = NO;
    if (![[AWDataHelper shared] hasLogined]) {
        UIViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
        loginController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:loginController animated:NO completion:nil];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"My watches" style:UIBarButtonItemStyleDone target:self action:@selector(viewWatches:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[AWDataHelper shared] hasLogined] && [AWDataHelper shared].user.Item.DeviceCount == 0 && [AWDataHelper shared].shouldAddDevice) {
        [AWDataHelper shared].shouldAddDevice = NO;
        [self goAddDevice];
    }
}

- (void)goAddDevice {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"addDevice"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewWatches:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"deviceList"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
