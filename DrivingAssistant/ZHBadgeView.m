//
//  ZHBadgeView.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/1.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ZHBadgeView.h"

#define ZHBadgeTitleFont [UIFont systemFontOfSize:11]

@implementation ZHBadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImage *backgroundImage = [UIImage imageNamed:@"main_badge"];
        self.size = backgroundImage.size;
        self.titleLabel.font = ZHBadgeTitleFont;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    if (badgeValue == nil || [badgeValue isEqualToString:@""] || [badgeValue isEqualToString:@"0"]) {
        self.hidden = YES;
        return;
    }
    else
    {
        self.hidden = NO;
    }
    [self setTitle:badgeValue forState:UIControlStateNormal];
    
    CGFloat titleW = [badgeValue boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ZHBadgeTitleFont} context:nil].size.width;
    if (titleW > self.width) {
        [self setBackgroundImage:nil forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"new_dot"] forState:UIControlStateNormal];
    }
    else
    {
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
    }

}

@end
