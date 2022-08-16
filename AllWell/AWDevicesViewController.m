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
@property(nonatomic, strong)AWDeviceListModel *listModel;
@end

@implementation AWDevicesViewController

+ (instancetype)viewController {
    AWDevicesViewController *devicesController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"deviceList"];
    return devicesController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Watches";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Device" style:UIBarButtonItemStyleDone target:self action:@selector(addDevice:)];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getDeviceList];
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
    [dict setObject:@"en" forKey:@"Language"];
    [dict setObject:@0 forKey:@"TimeOffset"];

//    [dict setObject:@"allwellapp" forKey:@"LoginName"];
//    [dict setObject:@"10" forKey:@"GroupId"];
    [[AWNetwork sharedInstance] POST:@"Device/PersonDeviceList" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {

        NSInteger code = [[responseObject objectForKey:@"State"] intValue];
        if (code == 100) {
            [self.devicesTableView reloadData];
            //无数据无表
        } else {
            self.listModel = [AWDeviceListModel yy_modelWithDictionary:responseObject];
            if (self.listModel.Items.count && ![AWDataHelper shared].device) {
                [AWDataHelper shared].device = self.listModel.Items.firstObject;
            }
            [self.devicesTableView reloadData];
        }
        
    } failure:^(NSString * _Nonnull error) {
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModel.Items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kItemCellID = @"deviceCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:kItemCellID forIndexPath:indexPath];
    UILabel *nameLabel = [cell viewWithTag:1];
    UILabel *imeiLabel = [cell viewWithTag:2];
    UIButton *delButton = [cell viewWithTag:3];
    [delButton addTarget:self action:@selector(unBind:) forControlEvents:UIControlEventTouchUpInside];
    AWDeviceModel *model = [self.listModel.Items objectAtIndex:indexPath.row];
    nameLabel.text = model.Name;
    imeiLabel.text = model.SerialNumber;
    return cell;
}

- (void)unBind:(UIButton *)sender {
    UIView *superView = sender.superview;
    while (![superView isKindOfClass:[UITableViewCell class]]) {
        superView = [superView superview];
    }
    UITableViewCell *cell = (UITableViewCell *)superView;
    NSIndexPath *cellPath = [self.devicesTableView indexPathForCell:cell];
    [self unbindDevice:self.listModel.Items[cellPath.row]];
}

- (void)unbindDevice:(AWDeviceModel *)model {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:model.Id forKey:@"DeviceId"];
    [dict setObject:@"212" forKey:@"AppId"];
    [dict setObject:@(model.UserGroupId) forKey:@"UserGroupId"];
    [dict setObject:[AWDataHelper shared].user.Item.UserId forKey:@"UserId"];
    [dict setObject:@"en" forKey:@"Language"];
    [dict setObject:@0 forKey:@"TimeOffset"];
    [[AWNetwork sharedInstance] POST:@"AuthShare/RemoveShare" parameters:dict success:^(NSDictionary*  _Nullable responseObject) {
        NSInteger code = [[responseObject objectForKey:@"State"] intValue];
        if (code == 0) {
            [self.listModel.Items removeObject:model];
            [self.devicesTableView reloadData];
        }
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}


@end
