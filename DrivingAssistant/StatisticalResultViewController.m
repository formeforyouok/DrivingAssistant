//
//  StatisticalResultViewController.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/11.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "StatisticalResultViewController.h"
#import "UserManager.h"
#import "UserModel.h"
#import "StatisticalCell.h"
#import "StatisticalModel.h"
#import "PieView.h"
#import "CoordinateItem.h"

@interface StatisticalResultViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSFetchedResultsController *_controller;
    NSMutableArray *_dataSource;
    NSString *_percentOfPassExam;
}

@end

@implementation StatisticalResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"考试成绩统计";
    
    
    [self configController];
//    [self uiConfig];
    
    [self buildDataSource];
    
    [self buildView];
}

- (void)buildDataSource
{
    _dataSource = [[NSMutableArray alloc] init];
    NSInteger passScore = 0;
    NSInteger unpassScore = 0;
    for (int i = 0; i < _controller.fetchedObjects.count; i ++) {
        NSInteger currentScore = [[_controller.fetchedObjects[i]score]integerValue];
        if (currentScore > 90) {
            passScore ++;
        }
        else
        {
            unpassScore ++;
        }
    }
    
    CoordinateItem *item = [[CoordinateItem alloc]initWithX:@"0" withY:[NSString stringWithFormat:@"%d",passScore] withColor:[UIColor colorWithRed:0 green:0.63 blue:0.8 alpha:1]];
    [_dataSource addObject:item];
    
    CoordinateItem *item1 = [[CoordinateItem alloc]initWithX:@"1" withY:[NSString stringWithFormat:@"%d",unpassScore] withColor:[UIColor colorWithRed:1 green:0.2 blue:0.31 alpha:1]];
    [_dataSource addObject:item1];
    if ((passScore + unpassScore) > 0) {
        _percentOfPassExam = [NSString stringWithFormat:@"及格率:%d%%",100 * passScore / (passScore + unpassScore)];
    }
}

- (void)buildView
{
    if (_controller.fetchedObjects.count > 0) {
        self.navigationItem.title = @"考试成绩饼状图";
        CGPoint center = self.view.center;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 200, 40)];
        NSArray *title = @[@"及格部分",@"不及格部分"];
        NSArray *colors = @[[UIColor colorWithRed:0 green:0.63 blue:0.8 alpha:1],[UIColor colorWithRed:1 green:0.2 blue:0.31 alpha:1]];
        CGFloat labelW = view.width  / 3;
        CGFloat labelH = view.height / 2;
        
        for (int i = 0; i < 2; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,i *(labelH - 5),labelW,labelH - 10)];
            label.text = title[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:9];
            label.adjustsFontSizeToFitWidth = YES;
            [view addSubview:label];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(labelW, i * (labelH - 5), view.width - labelW, labelH - 10)];
            lineView.backgroundColor = colors[i];
            [view addSubview:lineView];
        }
        [self.view addSubview:view];
        center.y = 100;
        view.center = center;
        
        CGFloat getLastY = CGRectGetMaxY(view.frame);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        center.y = getLastY + label.height / 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _percentOfPassExam;
        label.center = center;
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [UIColor colorWithRed:1 green:0.55 blue:0 alpha:1];
        [self.view addSubview:label];
        
        PieView *pieView = [[PieView alloc] initWithFrame:CGRectMake(5, 100, 300, 300) DataSource:_dataSource withAnimation:YES];
        center.y = CGRectGetMaxY(label.frame) + pieView.height/2;
        pieView.center = center;
        [self.view addSubview:pieView];


    }
    else
    {
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, ZHScreenWidth, ZHScreenHeight);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"您还没有模拟考试过哟～";
        label.textColor = [UIColor lightGrayColor];
        [self.view addSubview:label];

    }
    
}

- (void)configController
{
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"UserModel"];
    NSManagedObjectContext *context = [[UserManager sharedManager]context];
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"currentDate" ascending:NO];
    req.sortDescriptors = @[sd];
    _controller = [[NSFetchedResultsController alloc] initWithFetchRequest:req managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _controller.delegate = self;
    [_controller performFetch:nil];
//    [self prepareData];
}

- (void)prepareData
{
    _dataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _controller.fetchedObjects.count; i ++) {
        StatisticalModel *model = [[StatisticalModel alloc] init];
        model.subject = [_controller.fetchedObjects[i]subject];
        model.carModel = [_controller.fetchedObjects[i]carModel];
        model.score = [_controller.fetchedObjects[i]score];
        model.currentDate = [_controller.fetchedObjects[i]currentDate];
        [_dataArray addObject:model];
    }
}

- (void)uiConfig
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_dataArray.count > 0) {
        CGRect frame = self.view.bounds;
        frame.origin.y = 64;
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];

    }
    else
    {
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, ZHScreenWidth, ZHScreenHeight);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"您还没有模拟考试过哟～";
        label.textColor = [UIColor lightGrayColor];
        [self.view addSubview:label];

    }

}

#pragma mark NSFetchedResultsControllerDelegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if(type == NSFetchedResultsChangeDelete)
    {
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [_tableView reloadData];
    }
    
}


#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _controller.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatisticalCell *cell = [StatisticalCell cellWithTableView:tableView];
    [cell setModel:_dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == 1) {
        [[UserManager sharedManager]deleteUser:_controller.fetchedObjects[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
