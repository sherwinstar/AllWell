//
//  AWDevicesViewController.m
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/9.
//

#import "AWDevicesViewController.h"

@interface AWDevicesViewController ()
@property (nonatomic, weak)IBOutlet UITableView *devicesTableView;
@end

@implementation AWDevicesViewController

+ (instancetype)viewController {
    AWDevicesViewController *devicesController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"deviceList"];
    return devicesController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Device" style:UIBarButtonItemStyleDone target:self action:@selector(addDevice:)];
    // Do any additional setup after loading the view.
}

- (void)addDevice:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"addDevice"];
    [self.navigationController pushViewController:controller animated:YES];
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
