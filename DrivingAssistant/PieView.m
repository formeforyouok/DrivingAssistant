//
//  PieView.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/15.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "PieView.h"
#import "CoordinateItem.h"
#import "PieView.h"
#define Angle(percent) 2 * M_PI * percent
#define PIE_RADIUS (self.frame.size.height > self.frame.size.width?self.frame.size.width:self.frame.size.height)/4
#define ANIMATION_DURING 0.5
@interface PieView()

@property (nonatomic,assign) BOOL isAnimation;

@property (nonatomic,strong) NSMutableArray *dataSource;

//角度数组
@property (nonatomic,strong) NSMutableArray *angleArray;

//百分比数组
@property (nonatomic,strong) NSMutableArray *percentArray;

@end

@implementation PieView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/




- (id)initWithFrame:(CGRect)frame
         DataSource:(NSMutableArray *)dataSource
      withAnimation:(BOOL)isAnimation;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = frame;
        self.dataSource = [NSMutableArray arrayWithArray:dataSource];
        self.isAnimation = isAnimation;
        self.pieRadius = self.width / 2;
        [self buildDataSourceWith:dataSource];
    }
    return self;
}

- (void)buildDataSourceWith:(NSMutableArray *)dataSource
{
    self.dataSource = [NSMutableArray arrayWithArray:dataSource];
    
    __block CGFloat totalData = 0.0;
    __weak PieView *weakSelf = self;
    self.percentArray = [NSMutableArray arrayWithCapacity:0];
    self.angleArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.dataSource enumerateObjectsUsingBlock:^(CoordinateItem *obj, NSUInteger idx, BOOL *stop) {
        totalData = totalData + [obj.coordinateY floatValue];
    }];
    
    [self.dataSource enumerateObjectsUsingBlock:^(CoordinateItem *obj, NSUInteger idx, BOOL *stop) {
        CGFloat percent = [obj.coordinateY floatValue] / totalData;
        NSNumber *percentNumber = [NSNumber numberWithFloat:percent];
        [weakSelf.percentArray addObject:percentNumber];
        
        CGFloat angle = Angle(percent);
        NSNumber *angleNumber = [NSNumber numberWithFloat:angle];
        [weakSelf.angleArray addObject:angleNumber];
    }];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    if ((self.pieRadius == 0) || (self.pieRadius > PIE_RADIUS)) {
        self.pieRadius = PIE_RADIUS;
    }
    
    __weak PieView *weakSelf = self;
    __block CGFloat endAngle = 0.0;
    __block CGFloat startAngle = 0.0;
    [self.angleArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        CGFloat duringAngle = [obj floatValue];
        
        startAngle = endAngle;
        
        endAngle = startAngle + duringAngle;
        
        [weakSelf drawPinWithStartAngle:startAngle withEndAngle:endAngle withIndex:idx];
    }];
}

/**
 *  @author hao zhan
 *
 *  绘制扇形
 *
 *  @param startAngle 扇形的开始角度
 *  @param endAngle   扇形的结束角度
 *  @param idx        数据项的序号
 */


- (void)drawPinWithStartAngle:(CGFloat)startAngle
                 withEndAngle:(CGFloat)endAngle
                    withIndex:(NSUInteger)idx
{
    CAShapeLayer *pieLayer = [CAShapeLayer layer];
    
    pieLayer.lineWidth = self.pieRadius * 2;
    
    pieLayer.lineCap = kCALineCapButt;
    
    CoordinateItem *item = [self.dataSource objectAtIndex:idx];
    pieLayer.strokeColor = item.itemColor.CGColor;
    pieLayer.fillColor = nil;
    
    CGMutablePathRef piePath = CGPathCreateMutable();
//    CGPathAddArc(piePath, &CGAffineTransformIdentity, self.center.x, self.center.y, self.pieRadius, startAngle, endAngle, NO);
     CGPathAddArc(piePath, &CGAffineTransformIdentity, self.width / 2, self.height / 2, self.pieRadius, startAngle, endAngle, NO);
    pieLayer.path = piePath;
    if (self.isAnimation) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = ANIMATION_DURING;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        
        pathAnimation.autoreverses = NO;
        pathAnimation.fillMode = kCAFillModeForwards;
        [pieLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    }
    [self.layer addSublayer:pieLayer];
}


@end
