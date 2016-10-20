//
//  ExerciseViewController.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/5.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ExerciseViewController.h"
#import "ExamViewController.h"
#import "ExerciseModel.h"
#import "MBProgressHUD.h"
#import "LicenseTypeViewController.h"
#import "UserModel.h"
#import "UserManager.h"
#import "MokeExamResultViewController.h"
#import "FavoriteManager.h"
#define ZHDrivingLicenceType @"licenceType"
@interface ExerciseViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UpdateScoreDelegate>
{
    NSMutableArray *_dataArray;
    UIPageViewController *_pageViewController;
    NSInteger _currentPage;
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    NSTimer *_timer;
    NSMutableArray *_scoreArray;
    NSMutableArray *_vcArray;
    BOOL _isEditing;
    BOOL _isFavorite;
    ExerciseModel *_currentExerciseModel;
}
@end

@implementation ExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self prepareData];
    
}

- (void)prepareData
{
    _dataArray = [[NSMutableArray alloc] init];
    _scoreArray = [[NSMutableArray alloc] init];
    _vcArray = [[NSMutableArray alloc] init];
    _isEditing = _user != nil;
    _currentExerciseModel = [[ExerciseModel alloc] init];
    if (self.isOrder) {
        _currentPage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"currentPage"] integerValue];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notAction:) name:@"exercisemodel" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeAction) name:@"favoritechanged" object:nil];
     _isFavorite = [[FavoriteManager shardManager]isExists:_currentExerciseModel];
    for (int i = 0; i < 2000; i ++) {
        [_scoreArray addObject:@"0"];
    }
    NSDictionary *typeDict = [[NSUserDefaults standardUserDefaults]objectForKey:ZHDrivingLicenceType];
    self.subject = [typeDict objectForKey:@"subject"];
    self.model = [typeDict objectForKey:@"model"];

    NSDictionary *paramerter = @{@"subject":self.subject,
                                 @"model":self.model,
                                 @"key":ZHAppKey,
                                 @"testType":self.testType};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
    [[HTTPRequestManager sharedManager]POST:@"http://api2.juheapi.com/jztk/query?" withDict:paramerter complete:^(BOOL success, NSData *data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (success) {
            _dataArray = [ExerciseModel parseJsonWithData:data];
            if (self.secondOfExam && [self.subject integerValue] == 4) {
                [_dataArray removeObjectsInRange:NSMakeRange(49, 50)];
            }
            if (_dataArray.count > 0) {
                [self startConfig];
            }
            
        }
        else
        {
            [self errorAlert];
        }
    } isCache:[self.testType isEqualToString:@"order"]? YES : NO];
}

- (void)errorAlert
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"亲，网络不给力啊！" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)changeAction
{
    _isFavorite = [[FavoriteManager shardManager]isExists:_currentExerciseModel];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:_isFavorite ? @"bitauto_rating_bar_full":@"bitauto_rating_bar_empty" highImage:nil target:self action:@selector(favoriteBtnClick)];
}


- (void)startConfig
{

    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _titleLabel;
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentPage + 1,_dataArray.count];
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    for (int i = 0; i < _dataArray.count; i ++) {
        ExamViewController *examVC = [[ExamViewController alloc] init];
        examVC.model = _dataArray[i];
        examVC.currentPage = i;
        examVC.delegate = self;
        examVC.isExam = self.isExam;
        [_vcArray addObject:examVC];
    }
    [_pageViewController setViewControllers:@[_vcArray[_currentPage]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.view addSubview:_pageViewController.view];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    if (self.secondOfExam) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ZHScreenWidth - 88 - 44+5, 0, 88, 44)];
        _timeLabel.text = [NSString stringWithFormat:@"%ld : 00",self.secondOfExam / 60];
        _timeLabel.textColor = [UIColor whiteColor];
        [self.navigationController.navigationBar addSubview:_timeLabel];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
//        self.navigationItem.leftBarButtonItem = 
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"交卷" style:UIBarButtonItemStylePlain target:self action:@selector(exitExamBtnClick)];
    }
    _isFavorite = [[FavoriteManager shardManager]isExists:_currentExerciseModel];
    //    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:_isFavorite ? @"bitauto_rating_bar_full":@"bitauto_rating_bar_empty" highImage:nil target:self action:@selector(favoriteBtnClick)];
}

- (void)favoriteBtnClick
{
    ExerciseModel *model = [[ExerciseModel alloc] init];
    model = _currentExerciseModel;
    _isFavorite = [[FavoriteManager shardManager]isExists:_currentExerciseModel];
    if (_isFavorite) {
        [[FavoriteManager shardManager]deleteModel:model];
    }
    else
    {
        [[FavoriteManager shardManager]addModel:model];
    }
    _isFavorite = !_isFavorite;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changed" object:nil];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:_isFavorite ? @"bitauto_rating_bar_full":@"bitauto_rating_bar_empty" highImage:nil target:self action:@selector(favoriteBtnClick)];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:_isFavorite ?@"收藏成功":@"取消收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)notAction:(NSNotification *)not
{
    NSDictionary *dict = not.userInfo;
    _currentExerciseModel = dict[@"currentmodel"];
    _isFavorite = [[FavoriteManager shardManager]isExists:_currentExerciseModel];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:_isFavorite ? @"bitauto_rating_bar_full":@"bitauto_rating_bar_empty" highImage:nil target:self action:@selector(favoriteBtnClick)];
    _currentPage = [_currentExerciseModel.identify integerValue];
    
    if (self.isOrder) {
         [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",_currentPage] forKey:@"currentPage"];
    }
}


- (void)exitExamBtnClick
{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否确定交卷?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)updateTimer
{
    self.secondOfExam --;
    NSInteger min = self.secondOfExam / 60;
    NSInteger second = self.secondOfExam % 60;
    _timeLabel.text = [NSString stringWithFormat:@"%02ld : %02ld",min,second];
    if (!self.secondOfExam) {
        [self endExam];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    ExamViewController *examVC = (ExamViewController *)viewController;
    NSInteger index = examVC.currentPage;
    index --;
    if (index < 0) {
        index = _dataArray.count - 1;
    }
    return _vcArray[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    ExamViewController *examVC = (ExamViewController *)viewController;
    NSInteger index = examVC.currentPage;
    index ++;
    if (index >= _dataArray.count) {
        index = 0;
    }
    return _vcArray[index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    ExamViewController *evc = (ExamViewController *)pageViewController.viewControllers[0];
    NSInteger index = evc.currentPage;
    _currentPage = index;
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",index + 1,_dataArray.count];
}



#pragma mark alertView相关代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self endExam];
    }
}

#pragma mark 结束考试
- (void)endExam
{
    [_timer setFireDate:[NSDate distantFuture]];
    [_timeLabel removeFromSuperview];
    for (int i = 0; i < _vcArray.count; i ++) {
        ExamViewController *evc = _vcArray[i];
        evc.isExam = NO;
        _vcArray[i] = evc;
    }
    NSInteger score = 0;
    for (int i = 0; i < 100; i ++) {
        score += [_scoreArray[i] integerValue];
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setAMSymbol:@"AM"];
    [formatter setPMSymbol:@"PM"];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
    NSString *currentDateStr = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    UIBarButtonItem *popPre = [UIBarButtonItem barButtonItemWithImage:@"navigationbar_back" highImage:@"navigationbar_back_highlighted" target:self action:@selector(popToPre)];
    self.navigationItem.leftBarButtonItem = popPre;

    if (_isEditing) {
        _user.score = [NSString stringWithFormat:@"%ld",score];
        _user.subject = self.subject;
        _user.carModel = self.model;
        _user.currentDate = currentDateStr;
        [[UserManager sharedManager]updateUser:_user completion:^(BOOL success, NSString *err) {
            MokeExamResultViewController *mokeExamResultVC = [[MokeExamResultViewController alloc] init];
            mokeExamResultVC.score = [NSString stringWithFormat:@"%ld",score];
            mokeExamResultVC.secondOfExam = self.secondOfExam;
            [self.navigationController pushViewController:mokeExamResultVC animated:YES];
        }];
    }
    else
    {
        [[UserManager sharedManager]addUser:^(UserModel *user) {
            user.score = [NSString stringWithFormat:@"%ld",score];
            user.subject = self.subject;
            user.carModel = self.model;
            user.currentDate = currentDateStr;
        } completion:^(BOOL success, NSString *err) {
            MokeExamResultViewController *mokeExamResultVC = [[MokeExamResultViewController alloc] init];
            mokeExamResultVC.score = [NSString stringWithFormat:@"%ld",score];
            mokeExamResultVC.secondOfExam = self.secondOfExam;
            [self.navigationController pushViewController:mokeExamResultVC animated:YES];
        }];
    }

}

- (void)popToPre
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)updateScore:(NSInteger)score
{
    _scoreArray[_currentPage] = [NSString stringWithFormat:@"%ld",score];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isOrder) {
        _currentPage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"currentPage"] integerValue];
    }

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
