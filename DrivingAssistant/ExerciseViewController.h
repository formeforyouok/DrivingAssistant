//
//  ExerciseViewController.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/5.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ViewController.h"

@class UserModel;
@class FavoriteModel;

@interface ExerciseViewController : ViewController

@property (nonatomic,retain) NSString *testType;

@property (nonatomic,copy) NSString *subject;

@property (nonatomic,copy) NSString *model;

@property (nonatomic,assign) NSInteger secondOfExam;

@property (nonatomic,assign) BOOL isExam;

@property (nonatomic,strong) UserModel *user;

@property (nonatomic,strong) FavoriteModel *favorite;

@property (nonatomic,assign) BOOL isOrder;

- (void)startConfig;

- (void)prepareData;

@end
