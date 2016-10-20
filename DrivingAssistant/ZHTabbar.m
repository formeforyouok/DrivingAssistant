//
//  ZHTabbar.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/1.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ZHTabbar.h"

#import "ZHTabBarItem.h"

@interface ZHTabbar()

@property (nonatomic,strong) NSMutableArray *tabBarbuttons;

@property (nonatomic,strong) UIButton *selectedButton;

@end

@implementation ZHTabbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (NSMutableArray *)tabBarbuttons
{
    if (_tabBarbuttons == nil) {
        _tabBarbuttons = [NSMutableArray array];
    }
    return _tabBarbuttons;
}

#pragma mark - TabBarButtonItem

- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    ZHTabBarItem *button = [[ZHTabBarItem alloc] init];
    button.item = item;
    button.tag = self.tabBarbuttons.count;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.tabBarbuttons.count == 0) {
        [self btnClick:button];
    }
    [self addSubview:button];
    [self.tabBarbuttons addObject:button];
}

- (void)btnClick:(UIButton *)button
{
    _selectedButton.selected = NO;
    button.selected = YES;
    _selectedButton = button;
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]) {
        [_delegate tabBar:self didSelectIndex:button.tag];
    }
}

#pragma  mark - 设置按钮的frame

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setUpAllAddButtonFrame];
}

- (void)setUpAllAddButtonFrame
{
    NSInteger i = 0;
    NSInteger count = self.tabBarbuttons.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    
    for (UIView *tabBarButton in self.tabBarbuttons) {
        tabBarButton.frame = CGRectMake( i * btnW, 0, btnW, btnH);
        i ++;
    }
}


@end
