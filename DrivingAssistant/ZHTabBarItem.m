//
//  ZHTabBarItem.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/1.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ZHTabBarItem.h"
#import "ZHBadgeView.h"

#define ZHImageRadio 0.7
#define ZHMargin 6


@interface ZHTabBarItem()

@property (nonatomic,weak) ZHBadgeView *badgeView;

@end


@implementation ZHTabBarItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeCenter;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return self;
}

- (UIButton *)badgeView
{
    if (_badgeView == nil) {
        ZHBadgeView *badgeView = [ZHBadgeView buttonWithType:UIButtonTypeCustom];
        [self addSubview:badgeView];
        _badgeView = badgeView;
    }
    return _badgeView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = self.width;
    CGFloat btnH = self.height;
    CGFloat imageH = btnH * ZHImageRadio;
    self.imageView.frame = CGRectMake(0, 0, btnW, imageH);
    
    CGFloat titleH = btnH - imageH;
    CGFloat titleY = imageH - 2;
    self.titleLabel.frame = CGRectMake(0, titleY, btnW, titleH);
    
    self.badgeView.x = self.width - self.badgeView.width - ZHMargin;
    self.badgeView.y = 0;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    [self setTitle:item.title forState:UIControlStateNormal];
    
    self.badgeView.badgeValue = item.badgeValue;
    
}


@end
