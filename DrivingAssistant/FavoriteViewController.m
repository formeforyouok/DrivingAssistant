//
//  FavoriteViewController.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/13.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "FavoriteViewController.h"
#import "ExamViewController.h"
#import "ExerciseModel.h"
#import "FavoriteManager.h"
#import "UIImageView+WebCache.h"
#import "FavoriteCell.h"
#import "ExamViewController.h"
#import "MBProgressHUD.h"
@interface FavoriteViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    //存储每个cell的dataArray
    NSMutableArray *_dataArray;
    BOOL _isEditing;
}


@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    
    [self uiConfig];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notAction) name:@"changed" object:nil];
}

- (void)loadData
{
    _dataArray = [[NSMutableArray alloc] init];
    _dataArray = [[FavoriteManager shardManager]allModels];
}

- (void)notAction
{
    [self loadData];
    for (int i = self.view.subviews.count - 1; i >= 0; i --) {
        UIView *view = self.view.subviews[i];
        [view removeFromSuperview];
    }
    [self uiConfig];
}

- (void)uiConfig
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_dataArray.count ) {
        CGRect frame = self.view.bounds;
        frame.origin.y = 64;
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    else
    {
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, ZHScreenWidth, ZHScreenHeight);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"您没有收藏的题目哟～";
        label.textColor = [UIColor lightGrayColor];
        [self.view addSubview:label];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteCell *cell = [FavoriteCell cellWithTableView:tableView];
    ExerciseModel *model = _dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    _isEditing = editing;
    if (_isEditing) {
        [[FavoriteManager shardManager]beginTransaction];
    }
    else
    {
        [[FavoriteManager shardManager]commit];
        [self notAction];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    ExerciseModel *model = _dataArray[indexPath.row];
    NSDictionary *paramerter = @{@"subject":model.subject,
                                 @"model":model.carmodel,
                                 @"key":ZHAppKey,
                                 @"testType":@"order"};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
    if (paramerter) {
        [[HTTPRequestManager sharedManager]POST:@"http://api2.juheapi.com/jztk/query?" withDict:paramerter complete:^(BOOL success, NSData *data) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            if (success) {
                arr = [ExerciseModel parseJsonWithData:data];
                
                ExerciseModel *model = [[ExerciseModel alloc] init];
                model = _dataArray[indexPath.row];
                
                ExamViewController *examvc = [[ExamViewController alloc] init];
                examvc.model = [arr objectAtIndex:[model.identify integerValue]-1];
                [self.navigationController pushViewController:examvc animated:YES];
            }
            else
            {
                [self errorAlert];
            }
        } isCache:YES];

    }
}

- (void)errorAlert
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"亲，网络不给力啊！" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[FavoriteManager shardManager]deleteModel:_dataArray[indexPath.row]];
        [_dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [_tableView reloadData];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[FavoriteManager shardManager]rollback];
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
