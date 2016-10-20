//
//  ViewManager.m
//  限免
//
//  Created by HLP on 15/8/25.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ViewManager.h"
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]


@implementation ViewManager

+ (UILabel *)createLabelWithFrame:(CGRect)aFrame andText:(NSString *)aText andFont:(int)aFont
{
    UILabel *label = [[UILabel alloc] initWithFrame:aFrame];
    label.frame = aFrame;
    label.text = aText;
    label.font = [UIFont systemFontOfSize:aFont];
    label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = TEXT_COLOR;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return label;
}

@end
