//
//  ZHNavViewController.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/1.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ZHNavViewController.h"
#import "ZHTabbar.h"
@interface ZHNavViewController ()

@end

@implementation ZHNavViewController
+ (void)initialize
{
    if (self == [ZHNavViewController class]) {
        //设置导航条的颜色
        [self setUpNavBarColor];
        //设置导航条的标题
        [self setUpNavBarTitle];
        //设置导航条的按钮
        [self setUpNavBarButton];
    }
}

+ (void)setUpNavBarColor
{
    UINavigationBar *nav = [UINavigationBar appearanceWhenContainedIn:[ZHNavViewController class], nil];
    [nav setBarTintColor:[UIColor colorWithRed:0.18f green:0.65f blue:0.95f alpha:1.00f]];
}

+ (void)setUpNavBarTitle
{
    
    UINavigationBar *nav = [UINavigationBar appearanceWhenContainedIn:[ZHNavViewController class], nil];
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = ZHNavgationBarTitleFont;
    dictM[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [nav setTitleTextAttributes:dictM];
}

+ (void)setUpNavBarButton
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    //设置不可用状态下的按钮颜色
    NSMutableDictionary *disableDictM = [NSMutableDictionary dictionary];
    disableDictM[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:disableDictM forState:UIControlStateDisabled];
    
    //设置普通状态下的按钮颜色
    NSMutableDictionary *normalDictM = [NSMutableDictionary dictionary];
    normalDictM[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:normalDictM forState:UIControlStateNormal];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIBarButtonItem *popPre = [UIBarButtonItem barButtonItemWithImage:@"navigationbar_back" highImage:@"navigationbar_back_highlighted" target:self action:@selector(popToPre)];
        viewController.navigationItem.leftBarButtonItem = popPre;
        
//        UIBarButtonItem *popRoot = [UIBarButtonItem barButtonItemWithImage:@"navigationbar_more" highImage:@"navigationbar_more_highlighted" target:self action:@selector(popToRoot)];
//        viewController.navigationItem.rightBarButtonItem = popRoot;
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)popToRoot
{
    [self popToRootViewControllerAnimated:YES];
}

- (void)popToPre
{
    [self popViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UITabBarController *tabBarc = (UITabBarController *)ZHKeyWindow.rootViewController;
    
    for (UIView *tabBarButton in tabBarc.tabBar.subviews) {
        if (![tabBarButton isKindOfClass:[ZHTabbar class]]) {
            [tabBarButton removeFromSuperview];
        }
    }
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
