//
//  ZHPopAnimation.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/9.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ZHPopAnimation.h"
@interface ZHPopAnimation ()

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation ZHPopAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    }completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)animationDidStop:(CATransition *)anim finished:(BOOL)flag {
    [self.transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}

@end

