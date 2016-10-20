//
//  ZHTabbar.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/1.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHTabbar;

@protocol ZHTabBarDelegate <NSObject>

@optional
- (void)tabBar:(ZHTabbar *)tabBar didSelectIndex:(NSInteger)selectedIndex;

- (void)tabBarDidClickAddBtn:(ZHTabbar *)tabBar;

@end



@interface ZHTabbar : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property (nonatomic,weak) id<ZHTabBarDelegate>delegate;

@end
