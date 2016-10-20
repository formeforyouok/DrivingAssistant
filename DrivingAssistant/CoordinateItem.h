//
//  CoordinateItem.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/15.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoordinateItem : NSObject

@property (nonatomic,copy) NSString *coordinateX;

@property (nonatomic,copy) NSString *coordinateY;

@property (strong,nonatomic) UIColor *itemColor;

- (id)initWithX:(NSString *)x withY:(NSString *)y;

- (id)initWithX:(NSString *)x withY:(NSString *)y withColor:(UIColor *)itemColor;

@end
