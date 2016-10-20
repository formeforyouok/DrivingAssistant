//
//  PlatformView.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/2.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,PlatformViewDirector){
    PlatformViewDirectorNormal,
    PlatformViewDirectorLeft,
    PlatformViewDirectorRight,
    PlatformViewDirectorTopLeft,
    PlatformViewDirectorUpperLeft,
    PlatformViewDirectorTopRight,
    PlatformViewDirectorUpperRight,
    PlatformViewDirectorUp,
    PlatformViewDirectorDown,
    PlatformViewDirectorCenter
};

@protocol PlatformViewDataSource <NSObject>



@end


@protocol PlatformViewDelegate <NSObject>

- (void)platformView:(id)obj selectDirector:(PlatformViewDirector)director;

//- (void)platformView:(id)obj selectDirector:(NSInteger)director;

@end

@interface PlatformView : UIView

@property (nonatomic,retain) NSArray *titleArray;

@property (nonatomic,assign) id<PlatformViewDelegate>delegate;



@end
