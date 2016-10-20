//
//  MokeExamResultViewController.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/10.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "MokeExamResultViewController.h"

#define ZHDrivingLicenceType @"licenceType"
@interface MokeExamResultViewController ()

@end

@implementation MokeExamResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self uiconfig];
}

- (void)uiconfig
{
    
    CGPoint viewCenter = self.view.center;
    CGFloat kSpace = 20;
    
    viewCenter.y = 154;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 210 / 2)];
    if ([self.score integerValue] < 90) {
        imageView.image = [UIImage imageNamed:@"ic_no_data"];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"examPass.jpg"];
    }
    
    imageView.center = viewCenter;
    [self.view addSubview:imageView];
    
    CGFloat getImageViewY = CGRectGetMaxY(imageView.frame);
    viewCenter.y = getImageViewY + kSpace;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 40)];
    label.center = viewCenter;
    label.text = [NSString stringWithFormat:@"考试得分：%@",self.score];
    label.textColor = [UIColor colorWithRed:0.95f green:0.21f blue:0.29f alpha:1.00f];
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
    
    CGFloat getLabelY = CGRectGetMaxY(label.frame);
    NSDictionary *typeDict = [[NSUserDefaults standardUserDefaults]objectForKey:ZHDrivingLicenceType];
    NSString *subject = [typeDict objectForKey:@"subject"];

    if ([subject integerValue] == 1) {
        self.secondOfExam = 45 * 60 - self.secondOfExam;
    }
    else if ([subject integerValue] == 4)
    {
        self.secondOfExam = 30 * 60 - self.secondOfExam;
    }
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 150, 200, 40)];
    viewCenter.y = getLabelY + kSpace;
    timeLabel.center = viewCenter;
    timeLabel.text = [NSString stringWithFormat:@"考试用时：%ld分%ld秒",self.secondOfExam / 60,self.secondOfExam % 60];
    [self.view addSubview:timeLabel];
    
    
    CGFloat getTimeLabelY = CGRectGetMaxY(timeLabel.frame);
    UILabel *resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    viewCenter.y = getTimeLabelY + kSpace;
    resultLabel.center = viewCenter;

    if([self.score integerValue] < 90)
    {
        resultLabel.text = @"没有通过，继续加油!";
    }
    else
    {
        resultLabel.text = @"恭喜你通过考试!";
    }
    [self.view addSubview:resultLabel];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回首页" style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看试卷" style:UIBarButtonItemStylePlain target:self action:@selector(lookExamPaper)];
    

}

- (void)backToRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)lookExamPaper
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
