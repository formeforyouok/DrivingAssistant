//
//  ExamViewController.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/5.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseModel.h"

typedef NS_ENUM(NSUInteger,QuestionType){
    QuestionTypeJudge,
    QuestionTypeSingleSelection,
    QuestionTypeMultipleSelection
};

@protocol UpdateScoreDelegate <NSObject>

- (void)updateScore:(NSInteger)score;

@end



@interface ExamViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UIImageView *imageView;

@property (nonatomic,retain) UILabel *questionLabel;

@property (nonatomic,retain) UILabel *answerLabel;

@property (nonatomic,retain) UILabel *explainLabel;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,retain) UITableView *tableView;

@property (nonatomic,retain) ExerciseModel *model;

@property (nonatomic,assign) QuestionType *questionType;

@property (nonatomic,copy) NSString *subject;

@property (nonatomic,copy) NSString *carModel;

@property (nonatomic,assign) NSInteger score;

@property (nonatomic,assign) BOOL isExam;

@property (nonatomic,assign) id<UpdateScoreDelegate>delegate;

@end
