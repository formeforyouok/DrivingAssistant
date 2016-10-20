//
//  MokeExamViewController.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/9.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "MokeExamViewController.h"


#define ZHDrivingLicenceType @"licenceType"
@interface MokeExamViewController ()



@end

@implementation MokeExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self mokeTestUiconfig];
}

- (void)mokeTestUiconfig
{
    CGPoint viewCenter = self.view.center;
    
    NSDictionary *typeDict = [[NSUserDefaults standardUserDefaults]objectForKey:ZHDrivingLicenceType];
    self.subject = [typeDict objectForKey:@"subject"];
    self.model = [typeDict objectForKey:@"model"];

    
    UILabel *mokeExamTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    viewCenter.y = 100;
    mokeExamTitleLabel.center = viewCenter;
    if ([self.subject integerValue] == 1) {
        mokeExamTitleLabel.text = @"模拟考试（科目一）";
    }
    else
    {
        mokeExamTitleLabel.text = @"模拟考试（科目四）";
    }
    mokeExamTitleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:mokeExamTitleLabel];
    
    CGFloat getMaxMokeExamTitleLabelY = CGRectGetMaxY(mokeExamTitleLabel.frame);
    
    
    UILabel *mokeExamInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 290, 200)];
    viewCenter.y += getMaxMokeExamTitleLabelY + 20;
    mokeExamInfoLabel.center = viewCenter;
    NSString *testCarTypeStr;
    if ([self.model isEqualToString:@"c1"]) {
        testCarTypeStr = @"考试车型：全国通用 小车C1 C2";
    }
    else if ([self.model isEqualToString:@"a2"])
    {
        testCarTypeStr = @"考试车型：全国通用 货车A2 B2";
    }
    else if ([self.model isEqualToString:@"a1"])
    {
        testCarTypeStr = @"考试车型：全国通用 客车A1 B1";
    }
    
    NSString *numberOfQuestinStr;
    NSString *examTimeStr;
    
    if ([self.subject isEqualToString:@"1"]) {
        numberOfQuestinStr = @"考题数量：100题";
        examTimeStr = @"考试时间：45分钟";
        self.secondOfExam = 45 * 60;
    }
    else
    {
        numberOfQuestinStr = @"考题数量：50题";
        examTimeStr = @"考试时间：30分钟";
        self.secondOfExam = 30 * 60;
    }
    
    NSString *criterionOfAcceptability = @"合格标准：满分100分 及格90分";
    NSString *regularExam = @"出题规则：按公安部规定比例随机抽取";
    mokeExamInfoLabel.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n%@",testCarTypeStr,numberOfQuestinStr,examTimeStr,criterionOfAcceptability,regularExam];
    mokeExamInfoLabel.numberOfLines = 0;
    [self.view addSubview:mokeExamInfoLabel];
    
    CGFloat getMaxMokeExamInfoLabelY = CGRectGetMaxY(mokeExamInfoLabel.frame);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    viewCenter.y =getMaxMokeExamInfoLabelY + 50;
    button.center = viewCenter;
    [button setTitle:@"全真模拟考试" forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 4;
    [button setBackgroundColor:[UIColor colorWithRed:0.20f green:0.62f blue:0.84f alpha:1.00f]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(startExam) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startExam
{
    self.isExam = YES;
    [self prepareData];
    
}

//- (void)prepareData
//{
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
