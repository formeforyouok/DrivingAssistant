//
//  ZHRefresh.h
//  限免
//
//  Created by HLP on 15/8/18.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
typedef enum{
    ZHPullRefreshPulling = 0,
    ZHPullRefreshNormal,
    ZHPullRefreshLoading
}ZHPullRefreshState;

@class ZHRefresh;

@protocol ZHRefreshHeaderDelegate <NSObject>

- (void)zhRefreshTableHeaderDidTriggerRefresh:(ZHRefresh *)view;

- (BOOL)zhRefreshTableHeaderDataSourceIsLoading:(ZHRefresh *)view;

@optional
- (NSDate *)zhRefreshTableHeaderDataSourceLastUpdated:(ZHRefresh *)view;

@end

@interface ZHRefresh : UIView
{
    ZHPullRefreshState _state;
    
    UILabel *_lastUpdateLabel;
    UILabel *_statusLabel;
    CALayer *_arrowImage;
    UIActivityIndicatorView *_activityView;
}

@property (nonatomic,assign) id<ZHRefreshHeaderDelegate> delegate;

- (void)refreslastUpdateDate;

- (void)zhRefreshScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)zhRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)zhRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)view;


@end
