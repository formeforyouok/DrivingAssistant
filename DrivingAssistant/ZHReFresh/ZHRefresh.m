//
//  ZHRefresh.m
//  限免
//
//  Created by HLP on 15/8/18.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ZHRefresh.h"
#import "ViewManager.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@implementation ZHRefresh

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        CGRect labelFrame = CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f);
        UILabel *label = [ViewManager createLabelWithFrame:labelFrame andText:nil andFont:12.0f];
        [self addSubview:label];
        _lastUpdateLabel = label;
        
        CGRect statusLabelFrame = CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f);
        UILabel *statusLabel = [ViewManager createLabelWithFrame:statusLabelFrame andText:nil andFont:12.0f];
        [self addSubview:statusLabel];
        _statusLabel = statusLabel;
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
        layer.contentsGravity = kCAGravityResizeAspect;
        layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
        [[self layer]addSublayer:layer];
        _arrowImage = layer;
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        [self addSubview:view];
        _activityView = view;
        
        [self setState:ZHPullRefreshNormal];
    }
    return self;
}

- (void)setState:(ZHPullRefreshState)aState
{
    switch (aState) {
        case ZHPullRefreshNormal:
        {
            if (_state == ZHPullRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            _statusLabel.text = NSLocalizedString(@"为你刷新中...", @"pull down to refresh status");
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
        }
            break;
        case ZHPullRefreshLoading:
        {
            _statusLabel.text = NSLocalizedString(@"正在加载中...", @"Loading Status");
            [_activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
        }
            break;
        case ZHPullRefreshPulling:
        {
            _statusLabel.text = NSLocalizedString(@"正在刷新中....", @"松手刷新");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
        }
            break;
        default:
            break;
    }
    _state = aState;
}

#pragma mark ScrollView Methods
- (void)zhRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_state == ZHPullRefreshLoading) {
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
    }
    else if (scrollView.isDragging)
    {
        BOOL _isLoading = NO;
        if ([self.delegate respondsToSelector:@selector(zhRefreshScrollViewDataSourceDidFinishedLoading:)]) {
            _isLoading = [self.delegate zhRefreshTableHeaderDataSourceIsLoading:self];
        }
        if(_state == ZHPullRefreshPulling &&scrollView.contentOffset.y >-65.0f && scrollView.contentOffset.y < 0.0f && !_isLoading)
        {
            [self setState:ZHPullRefreshNormal];
        }
        else if (_state == ZHPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_isLoading) {
            [self setState:ZHPullRefreshPulling];
        }

        
        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)zhRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL _loading = NO;
    if ([self.delegate respondsToSelector:@selector(zhRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate zhRefreshTableHeaderDataSourceIsLoading:self];
    }
    if (scrollView.contentOffset.y <= -65.0f && !_loading) {
        if ([self.delegate respondsToSelector:@selector(zhRefreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate zhRefreshTableHeaderDidTriggerRefresh:self];
        }
        [self setState:ZHPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
        
    }
}

- (void)zhRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)view
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [view setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
    [self setState:ZHPullRefreshNormal];
}



@end
