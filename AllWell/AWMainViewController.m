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

@end

@implementation AWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![[AWDataHelper shared] hasLogined]) {
        UIViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
        loginController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:loginController animated:NO completion:nil];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"My watches" style:UIBarButtonItemStyleDone target:self action:@selector(viewWatches:)];
}

- (void)viewWatches:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"deviceList"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


@end
