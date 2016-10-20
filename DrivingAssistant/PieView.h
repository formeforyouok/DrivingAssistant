//
//  PieView.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/15.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieView : UIView

@property (nonatomic,assign) CGFloat pieRadius;

- (id)initWithFrame:(CGRect)frame
         DataSource:(NSMutableArray *)dataSource
         withAnimation:(BOOL)isAnimation;

@end
