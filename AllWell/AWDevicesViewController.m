//
//  AWDevicesViewController.m
//  AllWell
//
//  Created by Shaolin Zhou on 2022/8/9.
//

#import "AWDevicesViewController.h"
#import "UIColor+RGBA.h"
#import "AWNetwork.h"
#import "AWUserModel.h"
#import "AWDataHelper.h"
#import "AWDeviceModel.h"

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
//            [self checkDevice:@"865513041163079"];
        } else {
            AWDeviceListModel * model = [AWDeviceListModel yy_modelWithDictionary:responseObject];
            if (model.Items.count) {
                [AWDataHelper shared].device = model.Items.firstObject;
            }
            [self.devicesTableView reloadData];
        }
        
        
    } failure:^(NSString * _Nonnull error) {
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
