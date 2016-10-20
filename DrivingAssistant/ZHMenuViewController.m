//
//  ZHMenuViewController.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/9.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ZHMenuViewController.h"
#import "ZHMenuTableViewCell.h"
#import "LicenseTypeViewController.h"

@interface ZHMenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIImageView *headView;

@property (nonatomic,retain) UITableView *tableView;

@property (nonatomic,strong) UILabel *nickNameLabel;

@property (nonatomic,strong) UIButton *settingButton;

@property (nonatomic,strong) UILabel *infoLabel;

@property (nonatomic,strong) UIButton *nightButton;

@property (nonatomic,strong) NSArray *listArray;

@end

@implementation ZHMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back"]];
    [self uiconfig];
}

- (void)uiconfig
{
    self.listArray = @[@"更改驾照类型",@"我的收藏"];
    
    self.headView = [[UIImageView alloc] init];
    self.headView.image = [[UIImage imageNamed:@"me"]getRoundImage];
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@8);
        make.top.equalTo(@20);
        make.height.equalTo(@56);
        make.width.equalTo(@56);
    }];
    
    self.nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel.text = @"HLP";
    self.nickNameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(self.headView.mas_right).offset(5);
        make.height.equalTo(@27);
        make.width.equalTo(@240);
    }];
    
    UIImageView *lastView = self.headView;
    for (int i = 0; i < 3; i ++) {
        UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xingxing_yellow"]];
        [self.view addSubview:starImageView];
        
        [starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView.mas_right).offset(2);
            make.top.equalTo(self.nickNameLabel.mas_bottom);
            make.width.equalTo(@27);
            make.height.equalTo(@27);
        }];
        
        lastView = starImageView;
    }
    
    UIView *topLineView = [[UIView alloc]init];
    topLineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(5);
        make.height.equalTo(@1);
        make.left.equalTo(@5);
        make.width.equalTo(self.view);
    }];
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.text = @"考驾照，我能行";
    self.infoLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLineView.mas_bottom).offset(2);
        make.left.equalTo(@5);
        make.height.equalTo(@40);
        make.width.equalTo(self.view);
    }];
    
    UIView *lowLineView = [[UIView alloc]init];
    lowLineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lowLineView];
    [lowLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.mas_bottom).offset(2);
        make.height.equalTo(@1);
        make.left.equalTo(@5);
        make.width.equalTo(self.view);
    }];

    
    CGRect frame = self.view.bounds;
    frame.size.width = frame.size.width * 0.75;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 161, ZHScreenWidth * 0.75, 395)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 44 * ZHScreenWidth / 320;
    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.access
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lowLineView.mas_bottom).offset(8);
        make.width.equalTo(@170);
        make.left.equalTo(@8);
        make.height.equalTo(@395);
        
    }];
    
//    self.settingButton = [[UIButton alloc] init];
//    [self.settingButton setImage:[UIImage imageNamed:@"tab_me_nor"] forState:UIControlStateNormal];
//    [self.settingButton setTitle:@"设置" forState:UIControlStateNormal];
//    [self.view addSubview:self.settingButton];
//    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@8);
//        make.bottom.equalTo(@-5);
//        make.width.equalTo(@100);
//        make.height.equalTo(@40);
//    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHMenuTableViewCell *cell = [ZHMenuTableViewCell cellWithTableView:tableView];
    cell.textLabel.text = self.listArray[indexPath.row];
    if(!indexPath.row)
    {
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeCarLicenseType" object:nil userInfo:@{@"cellRow":[NSString stringWithFormat:@"%d",indexPath.row]}];
    
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
