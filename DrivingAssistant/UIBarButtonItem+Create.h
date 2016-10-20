//
//  UIBarButtonItem+Create.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/1.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Create)

+ (instancetype)barButtonItemWithImage:(NSString *)imageName highImage:(NSString *)highImageName target:(id)target action:(SEL)action;

@end
