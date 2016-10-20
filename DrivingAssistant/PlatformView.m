//
//  PlatformView.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/2.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "PlatformView.h"
@interface PlatformView()
{
    CGFloat _radius;//圆形半径
    CGFloat _startX;
    CGFloat _startY;
    CGFloat _centerX;
    CGFloat _centerY;
    CGFloat _angle;
    CGFloat _minRadius;//小圆半径
}

@end

@implementation PlatformView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
//        self.titleArray = @[@"模拟考试",@"章节练习",@"随机练习",@"错题重做",@"顺序练习",@"统计",@"考试类型"];
//        self.titleArray = @[@"模拟考试",@"驾驶技巧",@"随机练习",@"学车指南",@"顺序练习",@"统计",@"帮助"];
//        self.titleArray = @[@"模拟考试",@"错题集",@"随机练习",@"顺序练习",@"统计"];
        self.titleArray = @[@"模拟考试",@"错题集",@"随机练习",@"统计",@"顺序练习"];
        
        _startX = 5;
        _startY = _startX;
        _centerX = frame.size.width / 2;
        _centerY = frame.size.height / 2;
        _radius = _centerX - _startX;
        _angle = 0;
        _minRadius = _radius * 2.2/ 5;
//        [NSTimer scheduledTimerWithTimeInterval:1.0 / 60 target:self selector:@selector(testAction) userInfo:nil repeats:YES];
    }
    return self;
    
}

-(void)testAction
{
    _angle ++;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 0.97f, 0.97f, 0.97f, 1.00f);
    CGContextSetLineWidth(ctx, 10);
    //画大圆
    CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextAddEllipseInRect(ctx, CGRectMake(_startX, _startY , _radius * 2, _radius * 2));
    CGContextFillPath(ctx);

    //画小圆
    CGContextAddEllipseInRect(ctx, CGRectMake(_centerX - _minRadius, _centerY - _minRadius , _minRadius * 2, _minRadius * 2));
    CGContextStrokePath(ctx);
    
   
    NSInteger number = self.titleArray.count - 1;
    CGFloat darc = M_PI * 2 / number;

    //画分割线
    for (int i = 0; i < number; i ++) {
        CGPoint p = CGPointMake(_centerX + _minRadius * cos(angle2arc(_angle)), _centerY + _minRadius *sin(angle2arc(_angle)));
        CGContextMoveToPoint(ctx, p.x, p.y);
        CGContextAddLineToPoint(ctx, _centerX + _radius * cos(angle2arc(_angle)), _centerY + _radius *sin(angle2arc(_angle)));
        CGContextStrokePath(ctx);
        _angle += arc2angle(darc);
    }
    
     NSArray *colors = @[[UIColor colorWithRed:0 green:0.63 blue:0.8 alpha:1], [UIColor colorWithRed:1 green:0.2 blue:0.31 alpha:1], [UIColor colorWithRed:0.53 green:0.78 blue:0 alpha:1], [UIColor colorWithRed:1 green:0.55 blue:0 alpha:1]];
//    NSString *centerStr = self.titleArray[0];
//    CGSize centerSize = [self labelAutoCalculateRectWith:centerStr Font:[UIFont systemFontOfSize:14] MaxSize:CGSizeMake(MAXFLOAT, 26)];
//    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
//    [centerStr drawAtPoint:CGPointMake(_centerX - centerSize.width / 2, _centerY + centerSize.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
//    UIImage *image = [UIImage imageNamed:@"jiakao_icon_yuanpan_moni"];
//    [image drawAtPoint:CGPointMake(_centerX - 46/2, _centerY - 40)];
////    [image drawInRect:CGRectMake(_centerX - centerSize.width / 2, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
////    _angle = 30;
//   
//    //文字半径
//    CGFloat titleRadius = _radius * 3 / 4;
//    for (int i = 1; i < self.titleArray.count; i ++) {
//        NSString *titleStr = self.titleArray[i];
//        CGSize otherTitleSize = [self labelAutoCalculateRectWith:titleStr Font:[UIFont systemFontOfSize:12] MaxSize:CGSizeMake(MAXFLOAT, 26)];
//        CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
//        [titleStr drawAtPoint:CGPointMake(_centerX + titleRadius * cos(angle2arc(_angle ) + darc / 2) - otherTitleSize.width / 2, _centerY + titleRadius * sin(angle2arc(_angle ) + darc / 2) - otherTitleSize.height / 2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
//        _angle += arc2angle(darc);
//        
//    }
    [self uiConfig];
    
}

- (void)uiConfig
{
    CGSize size = [self labelAutoCalculateRectWith:self.titleArray[0] Font:[UIFont systemFontOfSize:13] MaxSize:CGSizeMake(MAXFLOAT, 26)];
    NSArray *imageArray = @[@"jiakao_icon_yuanpan_moni",
                            @"jiakao_icon_yuanpan_weizuo",
                            @"jiakao_icon_yuanpan_suiji",
                            @"jiakao_icon_yuanpan_shunxu",
                            @"jiakao_icon_yuanpan_zhangjie",
                            @"jiakao_icon_yuanpan_tongji",
                            @"jiakao_icon_yuanpan_qianghua"];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat titleRadius = _radius * 2.9 / 4;
    CGFloat darc = M_PI * 2 / (self.titleArray.count - 1);
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        view.tag = 100 + i;
        [self addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        imageView.frame = CGRectMake((size.width - 44) / 2, 0, 44, 44);
        [view addSubview:imageView];
        
        
        UILabel *label = [[UILabel alloc] init];
        label.text = self.titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11];
        label.frame = CGRectMake(2, 45, size.width, 22);
        [view addSubview:label];
        
        if (i == 0) {
            view.frame = CGRectMake(_centerX - size.width / 2, _centerY - 33, size.width, 66);
        }
        else
        {
            view.frame = CGRectMake(_centerX + titleRadius * cos(angle2arc(_angle ) + darc / 2) - size.width / 2, _centerY + titleRadius * sin(angle2arc(_angle ) + darc / 2) - 66 / 2, size.width, 66);
            _angle += arc2angle(darc);
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
//    for (UIView *view in self.subviews) {
//        if (CGRectContainsPoint(view.frame, point)) {
//            [_delegate platformView:self selectDirector:view.tag];
//        }
//    }
    
    [self moveToPoint:point];
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
//    
//    [self moveToPoint:point];
//}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
//    
//    [self moveToPoint:point];
//}

- (void)moveToPoint2:(CGPoint)point
{
    PlatformViewDirector director;
    CGFloat sum = distance4p2p(point, CGPointMake(_centerX, _centerY));
    if (sum > _radius) {
        director = PlatformViewDirectorNormal;
    }
    else if (distance4p2p(point, CGPointMake(_centerX, _centerY)) <= _minRadius)
    {
        director = PlatformViewDirectorCenter;
    }
    else if ( delta42p(point, CGPointMake(_centerX, _centerY))> tan(angle2arc(60.0f)))
    {
        if (point.y < _centerY) {
            director = PlatformViewDirectorUp;//上
        }
        else
        {
            director = PlatformViewDirectorDown;//下
        }
    }
    else
    {
        //左上
        if (point.x < _centerX && point.y < _centerY) {
            director = PlatformViewDirectorTopLeft;
        }
        //左下
        else if (point.x < _centerX && point.y > _centerY)
        {
            director = PlatformViewDirectorUpperLeft;
        }
        //右上
        else if (point.x > _centerX && point.y < _centerY)
        {
            director = PlatformViewDirectorTopRight;
        }
        //右下
        else if (point.x > _centerX && point.y > _centerY)
        {
            director = PlatformViewDirectorUpperRight;
        }
    }
    [_delegate platformView:self selectDirector:director];
}

- (void)moveToPoint:(CGPoint)point
{
    PlatformViewDirector director;
    CGFloat sum = distance4p2p(point, CGPointMake(_centerX, _centerY));
    if (sum > _radius) {
        director = PlatformViewDirectorNormal;
    }
    else if (distance4p2p(point, CGPointMake(_centerX, _centerY)) <= _minRadius)
    {
        director = PlatformViewDirectorCenter;
    }
    else
    {
        //左上
        if (point.x < _centerX && point.y < _centerY) {
            director = PlatformViewDirectorTopLeft;
        }
        //左下
        else if (point.x < _centerX && point.y > _centerY)
        {
            director = PlatformViewDirectorUpperLeft;
        }
        //右上
        else if (point.x > _centerX && point.y < _centerY)
        {
            director = PlatformViewDirectorTopRight;
        }
        //右下
        else if (point.x > _centerX && point.y > _centerY)
        {
            director = PlatformViewDirectorUpperRight;
        }
    }
    [_delegate platformView:self selectDirector:director];

}

#pragma mark Method For Math
/**
 *  弧度转为角度
 *
 *  @param arc 弧度
 *
 *  @return 角度
 */
float arc2angle(float arc)
{
    return arc / M_PI * 180;
}
/**
 *  角度转为弧度
 *
 *  @param angle 角度
 *
 *  @return 弧度
 */

float angle2arc(float angle)
{
    return angle / 180 * M_PI;
}
/**
 *  根据两点计算斜率
 *
 *  @param p1  起始点
 *  @param p2  终点
 *
 *  @return 两点决定的斜率
 */

float delta42p(CGPoint p1,CGPoint p2)
{
    if (p1.x == p2.x) {
        return 0;
    }
    return abs((p1.y - p2.y) / (p1.x - p2.x));
}
/**
 *  计算两点之间距离
 *
 *  @param p1  起始点
 *  @param p2  终点
 *
 *  @return 两点间的距离
 */

float distance4p2p(CGPoint p1,CGPoint p2)
{
    return sqrt((p1.x-p2.x)*(p1.x - p2.x) + (p1.y- p2.y) * (p1.y - p2.y));
}
/**
 *  根据文字算出文字所占区域大小
 *
 *  @param text    文字内容
 *  @param font    字体
 *  @param maxSize 最大尺寸
 *
 *  @return 实际尺寸
 */
- (CGSize)labelAutoCalculateRectWith:(NSString*)text Font:(UIFont*)font MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary* attributes =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return labelSize;
}


@end
