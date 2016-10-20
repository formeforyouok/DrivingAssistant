//
//  UIImage+GetRoundImage.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/9.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "UIImage+GetRoundImage.h"

@implementation UIImage (GetRoundImage)

- (instancetype)getRoundImage {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat compare = self.size.width - self.size.height;
    CGFloat circleW, circleX, circleY;
    if (compare > 0) {
        circleW = self.size.height;
        circleY = 0;
        circleX = (self.size.width - circleW) / 2.0;
    } else if (compare == 0) {
        circleW = self.size.width;
        circleX = circleY = 0;
    } else {
        circleW = self.size.width;
        circleX = 0;
        circleY = (self.size.height - circleW) / 2.0;
    }
    CGRect circleRect = CGRectMake(circleX, circleY, circleW, circleW);
    CGContextAddEllipseInRect(ctx, circleRect);
    CGContextClip(ctx);
    
    [self drawInRect:circleRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
