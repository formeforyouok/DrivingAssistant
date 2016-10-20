//
//  ZHTabBarController.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/1.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ZHTabBarController.h"
#import "ZHHomeViewController.h"
#import "ZHProfileViewController.h"

#import "ZHTabBarItem.h"
#import "ZHNavViewController.h"
#import "ZHTabbar.h"

#import "ZHMenuViewController.h"


@interface ZHTabBarController ()<ZHTabBarDelegate>

@property (nonatomic,assign) NSInteger selectIndex;

@property (nonatomic,weak) ZHTabbar *customTabBar;

@property (nonatomic,strong) ZHHomeViewController *home;

@property (nonatomic,strong) ZHProfileViewController *profile;

@end

@implementation ZHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createTabbar];
    
    [self setUpAllChildViewController];
}


- (void)createTabbar
{
    ZHTabbar *tabBar = [[ZHTabbar alloc] initWithFrame:self.view.bounds];
    tabBar.frame = self.tabBar.bounds;
    tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background"]];
    tabBar.layer.borderWidth = 1;
    tabBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tabBar.delegate = self;
    [self.tabBar addSubview:tabBar];
    _customTabBar = tabBar;

}

- (void)setUpAllChildViewController
{
    ZHHomeViewController *home = [[ZHHomeViewController alloc] init];
    [self setUpOndeChildViewController:home title:@"驾考" imageName:@"tabbar_home_n" selectImageName:@"tabbar_home_s"];
    
    ZHProfileViewController *profile = [[ZHProfileViewController alloc] init];
    [self setUpOndeChildViewController:profile title:@"我的" imageName:@"tabbar_profile_n" selectImageName:@"tabbar_profile_s"];
}

- (void)setUpOndeChildViewController:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName
{
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    UIImage *selectImage = [UIImage imageNamed:selectImageName];
    
    vc.tabBarItem.selectedImage = selectImage;
    ZHNavViewController *nav = [[ZHNavViewController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
    [self.customTabBar addTabBarButtonWithItem:vc.tabBarItem];
}

- (void)tabbarAction:(UIButton *)item
{
    for (ZHTabBarItem *item in self.tabBar.subviews) {
        if ([item isKindOfClass:[UIButton class]]) {
            item.selected = NO;
        }
    }
    
    item.selected = YES;
    NSInteger index = item.tag - 100;
    self.selectedIndex = index;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if (![tabBarButton isKindOfClass:[ZHTabbar class]]) {
            [tabBarButton removeFromSuperview];
        }
    }
}

- (void)tabBar:(ZHTabbar *)tabBar didSelectIndex:(NSInteger)selectedIndex
{
    if (selectedIndex == 0 && selectedIndex == _selectIndex) {
        
    }
    self.selectedIndex = selectedIndex;;
    _selectIndex = selectedIndex;
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
