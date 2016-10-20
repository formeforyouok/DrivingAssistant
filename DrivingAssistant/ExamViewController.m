//
//  ExamViewController.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/5.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ExamViewController.h"
#import "ItemModel.h"
#import "ExamCell.h"
#import "UIImageView+WebCache.h"
#import "ZHRefresh.h"
#import "PhotoViewController.h"
#import "UIImageView+GetWebImageSize.h"
#import "SCGIFImageView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FavoriteManager.h"


#define ZHDrivingLicenceType @"licenceType"
@interface ExamViewController ()<ZHRefreshHeaderDelegate>
{
    NSMutableArray *_dataArray;
    CGSize _questionSize;
    CGSize _explainSize;
    NSDictionary *_resultDict;
    BOOL _isSelected;//是否提交答案
    BOOL _isRefreshing;
    ZHRefresh *_zhRefresh;
    CGSize _imageViewSize;
    MPMoviePlayerViewController *_player;
    BOOL _isFavorite;
}
@end

@implementation ExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self uiconfig];
}


- (void)loadData
{
    _dataArray = [[NSMutableArray alloc] init];
    _isSelected = NO;
    _imageViewSize = [UIImageView downloadImageSizeWithURL:self.model.url];
    _isFavorite = [[FavoriteManager shardManager]isExists:self.model];
    
    NSDictionary *typeDict = [[NSUserDefaults standardUserDefaults]objectForKey:ZHDrivingLicenceType];
    self.subject = [typeDict objectForKey:@"subject"];
    self.carModel = [typeDict objectForKey:@"model"];
    if (![self.model.url isEqualToString:@""]) {
        if ( _imageViewSize.width == 0 || _imageViewSize.height == 0) {
            _imageViewSize = CGSizeMake(ZHScreenWidth - 30, 100);
        }
    }

    NSArray *imageNameArr = @[@"icon_practice_a_n_qingxin_big",
                              @"icon_practice_b_n_qingxin_big",
                              @"icon_practice_c_n_qingxin_big",
                              @"icon_practice_d_n_qingxin_big"];
    NSArray *imageNameSelectedArr = @[@"icon_practice_a_s_qingxin_big",
                                      @"icon_practice_b_s_qingxin_big",
                                      @"icon_practice_c_s_qingxin_big",
                                      @"icon_practice_d_s_qingxin_big"];
    NSMutableArray *itemArr = [[NSMutableArray alloc] init];
    if ([self.model.item1 isEqualToString:@""]) {
        [itemArr addObject:@"正确"];
        self.questionType = QuestionTypeJudge;
    }
    if ([self.model.item2 isEqualToString:@""]) {
        [itemArr addObject:@"错误"];
        self.questionType = QuestionTypeJudge;
    }
    else
    {
        if ([self.model.item3 isEqualToString:@""]) {
            self.questionType = QuestionTypeJudge;
        }
        else
        {
            if ([self.model.answer integerValue]<=4) {
                self.questionType = QuestionTypeSingleSelection;
            }
            else
            {
                self.questionType = QuestionTypeMultipleSelection;
            }
        }
        [itemArr addObject:self.model.item1];
        [itemArr addObject:self.model.item2];
    }
    [itemArr addObject:self.model.item3];
    [itemArr addObject:self.model.item4];
    
    for (int i = 0; i < 4; i ++) {
        ItemModel *model = [[ItemModel alloc] init];
        model.imageName = imageNameArr[i];
        model.imageSelectedName = imageNameSelectedArr[i];
        model.imageRightName = @"jiakao_exercise_option_t_d_big";
        model.imageErrorName = @"jiakao_exercise_option_f_d_big";
        model.item = itemArr[i];
        model.isSelected = NO;
        model.status = ItemStatusNormal;
        [_dataArray addObject:model];
    }
    _questionSize = [self labelAutoCalculateRectWith:self.model.question Font:[UIFont systemFontOfSize:16] MaxSize:CGSizeMake(self.view.width - 30, MAXFLOAT)];
    
    _explainSize = [self labelAutoCalculateRectWith:self.model.explains Font:[UIFont systemFontOfSize:16] MaxSize:CGSizeMake(self.view.width - 30, MAXFLOAT)];
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"Result" ofType:@"plist"];
    _resultDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];

}

- (void)refreshData
{
    _isRefreshing = YES;
    //延迟1秒调用
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [_zhRefresh zhRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        if (_zhRefresh) {
            [self loadData];
            [_tableView reloadData];
            _isRefreshing = NO;

        }
    });
    
}


#pragma mark -创建界面
- (void)uiconfig
{
    
    CGRect frame = self.view.bounds;
    frame.origin.y = 64;
    frame.size.height -= 64;
    _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    frame = _tableView.bounds;
    frame.origin.y = -frame.size.height;
    _zhRefresh = [[ZHRefresh alloc]initWithFrame:frame];
    _zhRefresh.delegate = self;
    [_tableView addSubview:_zhRefresh];
}

#pragma mark tableView相关代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_isSelected || self.isExam) {
        return 1;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != 0) {
        return 0;
    }
    if ([self.model.item3 isEqualToString:@""]) {
        return 2;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamCell *cell = [ExamCell cellWithTableView:tableView];
    cell.model = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view= [[UIView alloc]init];
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appdetail_background"]];
    [view addSubview:backView];
    if (!section) {
        backView.frame = CGRectMake(0, 5, self.view.width, _questionSize.height + 10);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.view.width - 30, _questionSize.height)];
        label.text = self.model.question;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:16];
//        label.backgroundColor = [UIColor whiteColor];
        
        [backView addSubview:label];
        
        
        if (![self.model.url isEqualToString:@""]) {
            CGFloat imageViewW = _imageViewSize.width;
            CGFloat imageViewH = _imageViewSize.height;
            if (imageViewW > ZHScreenWidth) {
                imageViewW = ZHScreenWidth - 30;
            }
            if (!imageViewW) {
                imageViewW = ZHScreenWidth - 30;
            }
            if (!imageViewH) {
                imageViewH = 70;
            }
            NSString *type = [self.model.url substringFromIndex:self.model.url.length - 3 ];
//            NSLog(@"type = %@",type);
            if([type isEqualToString:@"swf"])
            {
                _imageViewSize.width = 320 ;
                _imageViewSize.height = 240 ;
                NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",self.model.identify] ofType:@"mp4"];
             
                NSString *htmlStr = [NSString stringWithFormat:@"<!DOCTYPE html><html><body> <video width=\"%f\" height=\"%f\" controls><source src=\"%@\" type=\"video/mp4\">您的浏览器不支持 HTML5 video 标签。 </video> </body></html>",_imageViewSize.width,_imageViewSize.height,path];
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(15, _questionSize.height + 20, _imageViewSize.width, _imageViewSize.height)];
                [webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:path]];
                [view addSubview:webView];
                
                
//                NSString *path = [[NSBundle mainBundle]pathForResource:@"38.gif" ofType:nil];
//                NSData *imageData = [NSData dataWithContentsOfFile:path];
//                
//                SCGIFImageView  *imageView = [[SCGIFImageView alloc] initWithFrame:CGRectMake(15, _questionSize.height + 5 + 15,_imageViewSize.width,_imageViewSize.height)];
//                [imageView setData:imageData];
//                [view addSubview:imageView];

                
            }
            else
            {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, _questionSize.height + 5 + 15, imageViewW, imageViewH)];
                [imageView setImageWithURL:[NSURL URLWithString:self.model.url] placeholderImage:[UIImage imageNamed:@"loading"]];
                [view addSubview:imageView];
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
                [imageView addGestureRecognizer:tap];
                view.frame = CGRectMake(0, 0, self.view.width, 120);
            }
        }
    }
    else if (section == 1)
    {
        backView.frame = CGRectMake(0, 5, self.view.width, 30);
        [view addSubview:backView];
        UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.view.width - 30, 20)];
        NSString *resultStr = [_resultDict objectForKey:self.model.answer];
        NSString *attrStr = @"答案:";
        if ([self.model.item3 isEqualToString:@""]) {
            if ([self.model.answer isEqualToString:@"1"]) {
                label.text = [attrStr stringByAppendingString:@"正确"];
            }
            else
            {
                label.text = [attrStr stringByAppendingString:@"错误"];
            }
        }
        else
        {
            if ([self.model.answer isEqualToString:@"1"]) {
                label.text = [attrStr stringByAppendingString:@"A"];
            }
            else if([self.model.answer isEqualToString:@"2"])
            {
                label.text = [attrStr stringByAppendingString:@"B"];
            }
            else
            {
                label.text = [attrStr stringByAppendingString:resultStr];
            }

        }
        label.numberOfLines = 0;
        [backView addSubview:label];
        view.frame = CGRectMake(0, 0, self.view.width, 40);
    }
    else if (section == 2)
    {
        backView.frame = CGRectMake(0, 5, self.view.width , _explainSize.height + 10);
        [view addSubview:backView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.view.width - 30, _explainSize.height)];
        label.text = [@"解析:" stringByAppendingString:self.model.explains];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:16];
        label.adjustsFontSizeToFitWidth = YES;
        [backView addSubview:label];
        view.frame = CGRectMake(0, 0, self.view.width, _explainSize.height + 20);
    }
    return view;
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    photoVC.imageUrl = self.model.url;
    [self presentViewController:photoVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        NSString *type = @"";
        if (![self.model.url isEqualToString:@""]) {
            type  = [self.model.url substringFromIndex:self.model.url.length - 3 ];
        }
        if ([type isEqualToString:@"swf"]) {
            return _questionSize.height + 240 + 40;
        }
        return _questionSize.height + _imageViewSize.height + 40;
    }
    else if (section == 2)
    {
        return _explainSize.height + 20;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemModel *model = _dataArray[indexPath.row];
    CGSize size = [self labelAutoCalculateRectWith:model.item Font:[UIFont systemFontOfSize:20] MaxSize:CGSizeMake(ZHScreenWidth - 60, MAXFLOAT)];
    return size.height + 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isSelected || self.isExam) {
        if (self.questionType == QuestionTypeJudge || self.questionType == QuestionTypeSingleSelection) {
            
            ItemModel *model = [[ItemModel alloc] init];
            model = _dataArray[indexPath.row];
            for (ItemModel *model in _dataArray) {
                model.isSelected = NO;
                model.status = ItemStatusNormal;
            }
            if ((indexPath.row + 1)== [self.model.answer integerValue]) {
                if ([self.subject integerValue] == 1) {
                    self.score = 1;
                }
                else
                {
                    self.score = 2;
                }
                if (self.isExam) {
                    model.status = ItemStatusSelected;
                }
                else
                {
                    model.status = ItemStatusRight;
                }
                if (_isFavorite && !self.isExam) {
                    [[FavoriteManager shardManager]deleteModel:self.model];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"favoritechanged" object:nil];
                }

            }
            else
            {
                self.score = 0;
                if (!_isFavorite && !self.isExam) {
                    [[FavoriteManager shardManager]addModel:self.model];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"favoritechanged" object:nil];
                }
                if (self.isExam) {
                    model.status = ItemStatusSelected;
                }
                else
                {
                    model.status = ItemStatusError;
                }
                
            }
            if ([self.delegate respondsToSelector:@selector(updateScore:)]) {
                [self.delegate updateScore:self.score];
            }
            model.isSelected = YES;
            _dataArray[indexPath.row] = model;
            _isSelected = YES;
        }
        else
        {
            ItemModel *model = [[ItemModel alloc] init];
            model = _dataArray[indexPath.row];
            model.isSelected = !model.isSelected;
            model.status = model.isSelected;
            _dataArray[indexPath.row] = model;
            
        }

    }
    [_tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width , 40)];
    view.backgroundColor = [UIColor colorWithRed:0.20f green:0.62f blue:0.84f alpha:1.00f];
    view.layer.cornerRadius = 4;
    UIButton *btn = [[UIButton alloc]initWithFrame:view.bounds];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    if (!section && !_isSelected && self.questionType == QuestionTypeMultipleSelection){
        return view;
    }
    return nil;
}

- (void)submitBtnClick
{
    
    NSString *answer = @"";
    if (!_isSelected) {
        for (int i = 0; i < _dataArray.count; i ++) {
            ItemModel *model = [[ItemModel alloc] init];
            model = _dataArray[i];
            if (model.isSelected) {
                switch (i) {
                    case 0:
                    {
                        answer = [answer stringByAppendingString:@"A"];
                    }
                        break;
                    case 1:
                    {
                        answer = [answer stringByAppendingString:@"B"];
                    }
                        break;
                    case 2:
                    {
                        answer = [answer stringByAppendingString:@"C"];
                    }
                        break;
                    case 3:
                    {
                        answer = [answer stringByAppendingString:@"D"];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        
        NSString *realAnswer = [_resultDict objectForKey:self.model.answer];
        
        
        if ([answer isEqualToString:realAnswer]) {
            self.score = 2;
            for (int i = 0; i < _dataArray.count; i ++) {
                ItemModel *model = [[ItemModel alloc]init];
                model = _dataArray[i];
                if (model.isSelected && !self.isExam) {
                    model.status = ItemStatusRight;
                }
                else if (self.isExam)
                {
                    model.status = ItemStatusSelected;
                }
                _dataArray[i] = model;
            }
            if (_isFavorite && !self.isExam) {
                [[FavoriteManager shardManager]deleteModel:self.model];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"favoritechanged" object:nil];
            }

        }
        else
        {
            if (!_isFavorite && !self.isExam) {
                [[FavoriteManager shardManager]addModel:self.model];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"favoritechanged" object:nil];
            }
            self.score = 0;
        }
        
        if ([self.delegate respondsToSelector:@selector(updateScore:)]) {
            [self.delegate updateScore:self.score];
        }

    }
    _isSelected = YES;
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    if (!section && !_isSelected && self.questionType == QuestionTypeMultipleSelection)
    {
        return 40;
    }
    return 0;
}


#pragma mark -下拉刷新代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_zhRefresh zhRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_zhRefresh zhRefreshScrollViewDidEndDragging:scrollView];
}

- (void)zhRefreshTableHeaderDidTriggerRefresh:(ZHRefresh *)view
{
    [self refreshData];
}

- (BOOL)zhRefreshTableHeaderDataSourceIsLoading:(ZHRefresh *)view
{
    return _isRefreshing;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isFavorite = [[FavoriteManager shardManager]isExists:self.model];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"exercisemodel" object:nil userInfo:@{@"currentmodel":self.model}];
    [_zhRefresh zhRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    [_tableView reloadData];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_zhRefresh zhRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
