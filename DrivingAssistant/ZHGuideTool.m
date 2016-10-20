//
//  ZHGuideTool.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/8.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ZHGuideTool.h"
#import "ZHTabBarController.h"
#import "LicenseTypeViewController.h"
#import "ZHMenuViewController.h"
#import "ZHNavViewController.h"
#import "ZHHomeViewController.h"
#define ZHVersionKey @"version"
#define ZHDrivingLicenceType @"licenceType"
@implementation ZHGuideTool
+ (void)guideRootViewController:(UIWindow *)window
{
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults] objectForKey:ZHVersionKey];
    NSString *verKey = (__bridge NSString *)kCFBundleVersionKey;
    
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[verKey];
    NSDictionary *currentDirivingType = [[NSUserDefaults standardUserDefaults] objectForKey:ZHDrivingLicenceType];
    if (![oldVersion isEqualToString:currentVersion] || !currentDirivingType) {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:ZHVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        LicenseTypeViewController *licenseTypeVc = [[LicenseTypeViewController alloc]init];
        window.rootViewController = licenseTypeVc;
    }
    else
    {
//        ZHTabBarController *tabBarController = [[ZHTabBarController alloc] init];
        ZHNavViewController *navi= [[ZHNavViewController alloc] initWithRootViewController:[ZHHomeViewController new]];
        window.rootViewController = navi;
    }
}

@end
