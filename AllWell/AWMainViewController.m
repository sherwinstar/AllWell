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
        AWLoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        loginController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:loginController animated:NO completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


@end
