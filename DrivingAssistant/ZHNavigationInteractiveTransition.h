//
//  ZHNavigationInteractiveTransition.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/9.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController,UIPercentDrivenInteractiveTransition;

@interface ZHNavigationInteractiveTransition : NSObject <UINavigationControllerDelegate>

- (instancetype)initWithViewController:(UIViewController *)vc;

- (void)handleControllerPop:(UIPanGestureRecognizer *)recognizer;

- (UIPercentDrivenInteractiveTransition *)interactivePopTransition;

@end
