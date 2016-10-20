//
//  CoordinateItem.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/15.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "CoordinateItem.h"

@implementation CoordinateItem

- (id)initWithX:(NSString *)x withY:(NSString *)y
{
    self = [super init];
    if (self) {
        self.coordinateX = x;
        self.coordinateY = y;
    }
    return self;
}

- (id)initWithX:(NSString *)x withY:(NSString *)y withColor:(UIColor *)itemColor
{
    self = [super init];
    if (self) {
        self.coordinateX = x;
        self.coordinateY = y;
        self.itemColor = itemColor;
    }
    return self;
}

@end
