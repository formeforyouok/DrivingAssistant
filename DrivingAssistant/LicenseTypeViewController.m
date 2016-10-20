//
//  LicenseTypeViewController.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/8.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "LicenseTypeViewController.h"
#import "CHTumblrMenuView.h"
#import "ZHTabBarController.h"
#import "ZHHomeViewController.h"
#import "ZHNavViewController.h"

#define ZHDrivingLicenceType @"licenceType"
@interface LicenseTypeViewController ()

@end

@implementation LicenseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    //进入ExerciceViewController界面
    [self chooseDrivingLicenseType];
    
    //请选择你的驾照类型
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 70, 120, 50);
    titleLabel.text = @"请选择驾考类型";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = [UIColor whiteColor];
    CGPoint offset = self.view.center;
    offset.y = 80;
    titleLabel.center = offset;
    [self.view addSubview:titleLabel];

}

- (void)chooseDrivingLicenseType
{
    CHTumblrMenuView *menuView = [[CHTumblrMenuView alloc] init];
    
    [menuView addMenuItemWithTitle:@"小车科目一\nC1、C2照" andIcon:[UIImage imageNamed:@"jiakao_btn_xztk_xiaoche_n.png"] andSelectedBlock:^{
//        ZHTabBarController *tabBarVc = [[ZHTabBarController alloc] init];
        NSDictionary *dict = @{@"subject":@"1",@"model":@"c1"};
        [[NSUserDefaults standardUserDefaults]setObject:dict forKey:ZHDrivingLicenceType];
        [[NSUserDefaults standardUserDefaults]synchronize];
//        ZHKeyWindow.rootViewController = tabBarVc;
        ZHNavViewController *navi= [[ZHNavViewController alloc] initWithRootViewController:[ZHHomeViewController new]];
        ZHKeyWindow.rootViewController = navi;
    }];
    [menuView addMenuItemWithTitle:@"货车科目一\nA2、B2照" andIcon:[UIImage imageNamed:@"jiakao_btn_xztk_huoche_n.png"] andSelectedBlock:^{
//        ZHTabBarController *tabBarVc = [[ZHTabBarController alloc] init];
        NSDictionary *dict = @{@"subject":@"1",@"model":@"a2"};
        [[NSUserDefaults standardUserDefaults]setObject:dict forKey:ZHDrivingLicenceType];
        [[NSUserDefaults standardUserDefaults]synchronize];
//        ZHKeyWindow.rootViewController = tabBarVc;
        ZHNavViewController *navi= [[ZHNavViewController alloc] initWithRootViewController:[ZHHomeViewController new]];
        ZHKeyWindow.rootViewController = navi;
    }];
    [menuView addMenuItemWithTitle:@"客车科目一\nA1、B1照" andIcon:[UIImage imageNamed:@"jiakao_btn_xztk_keche_n.png"] andSelectedBlock:^{
//        ZHTabBarController *tabBarVc = [[ZHTabBarController alloc] init];
        NSDictionary *dict = @{@"subject":@"1",@"model":@"a1"};
        [[NSUserDefaults standardUserDefaults]setObject:dict forKey:ZHDrivingLicenceType];
        [[NSUserDefaults standardUserDefaults]synchronize];
//        ZHKeyWindow.rootViewController = tabBarVc;
        ZHNavViewController *navi= [[ZHNavViewController alloc] initWithRootViewController:[ZHHomeViewController new]];
        ZHKeyWindow.rootViewController = navi;
        
    }];
    [menuView addMenuItemWithTitle:@"小车科目四\nC1、C2照" andIcon:[UIImage imageNamed:@"jiakao_btn_xztk_xiaoche_n.png"] andSelectedBlock:^{
//        ZHTabBarController *tabBarVc = [[ZHTabBarController alloc] init];
        NSDictionary *dict = @{@"subject":@"4",@"model":@"c1"};
        [[NSUserDefaults standardUserDefaults]setObject:dict forKey:ZHDrivingLicenceType];
        [[NSUserDefaults standardUserDefaults]synchronize];
//        ZHKeyWindow.rootViewController = tabBarVc;
        ZHNavViewController *navi= [[ZHNavViewController alloc] initWithRootViewController:[ZHHomeViewController new]];
        ZHKeyWindow.rootViewController = navi;
    }];
    [menuView addMenuItemWithTitle:@"货车科目四\nA2、B2照" andIcon:[UIImage imageNamed:@"jiakao_btn_xztk_huoche_n.png"] andSelectedBlock:^{
//        ZHTabBarController *tabBarVc = [[ZHTabBarController alloc] init];
        NSDictionary *dict = @{@"subject":@"4",@"model":@"a2"};
        [[NSUserDefaults standardUserDefaults]setObject:dict forKey:ZHDrivingLicenceType];
        [[NSUserDefaults standardUserDefaults]synchronize];
//        ZHKeyWindow.rootViewController = tabBarVc;
        ZHNavViewController *navi= [[ZHNavViewController alloc] initWithRootViewController:[ZHHomeViewController new]];
        ZHKeyWindow.rootViewController = navi;
        
    }];
    [menuView addMenuItemWithTitle:@"客车科目四\nA1、B1照" andIcon:[UIImage imageNamed:@"jiakao_btn_xztk_keche_n.png"] andSelectedBlock:^{
//        ZHTabBarController *tabBarVc = [[ZHTabBarController alloc] init];
        NSDictionary *dict = @{@"subject":@"4",@"model":@"a1"};
        [[NSUserDefaults standardUserDefaults]setObject:dict forKey:ZHDrivingLicenceType];
        [[NSUserDefaults standardUserDefaults]synchronize];
//        ZHKeyWindow.rootViewController = tabBarVc;
        ZHNavViewController *navi= [[ZHNavViewController alloc] initWithRootViewController:[ZHHomeViewController new]];
        ZHKeyWindow.rootViewController = navi;
    }];
    [self.view addSubview:menuView];
    menuView.frame = self.view.bounds;
//    [menuView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
