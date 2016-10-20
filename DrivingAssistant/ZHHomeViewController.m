//
//  ZHHomeViewController.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/2.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ZHHomeViewController.h"
#import "PlatformView.h"
#import "ExerciseViewController.h"
#import "MokeExamViewController.h"
#import "RandPraticeViewController.h"
#import "UIImage+GetRoundImage.h"
#import "LicenseTypeViewController.h"
#import "OrderPracticeViewController.h"
#import "ZHTabbar.h"
#import "StatisticalResultViewController.h"
#import "FavoriteViewController.h"


#define ZHScreenHeight [UIScreen mainScreen].bounds.size.height
#define ZHScreenWidth [UIScreen mainScreen].bounds.size.width
@interface ZHHomeViewController ()<PlatformViewDelegate>

@end

@implementation ZHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PlatformView *platform = [[PlatformView alloc] initWithFrame:CGRectMake(10, 100, 300 * ZHScreenWidth / 375, 300 * ZHScreenWidth / 375)];
    platform.center = self.view.center;
    platform.layer.borderWidth =1;
    platform.layer.borderColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f].CGColor;
    
    self.title = @"驾考";
    platform.delegate = self;
    [self.view addSubview:platform];
    self.view.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(0, 0, 33, 33);
    [self.leftBtn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn setImage:[[UIImage imageNamed:@"me"] getRoundImage] forState:UIControlStateNormal];
    UIBarButtonItem *barLeftBtn = [[UIBarButtonItem alloc]initWithCustomView:self.leftBtn];
    [self.navigationItem setLeftBarButtonItem:barLeftBtn];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notAction:) name:@"changeCarLicenseType" object:nil];
}

- (void)notAction:(NSNotification *)not
{
    NSDictionary *dict = not.userInfo;
    NSInteger index = [dict[@"cellRow"] integerValue];
//    UIView *window = self.navigationController.tabBarController.view.superview;
    UIView *window = self.navigationController.view.superview;
    [UIView animateWithDuration:0.3 animations:^{
        window.center = self.view.center;
        window.transform = CGAffineTransformScale(self.view.transform, 1.0, 1.0);
//        self.navigationController.tabBarController.view.userInteractionEnabled = YES;
        self.navigationController.view.userInteractionEnabled = NO;
        switch (index) {
            case 0:
            {
                LicenseTypeViewController *licenseVC = [[LicenseTypeViewController alloc] init];
                [self.navigationController pushViewController:licenseVC animated:YES];
            }
                break;
            case 1:
            {
                FavoriteViewController *favorite = [[FavoriteViewController alloc] init];
                [self.navigationController pushViewController:favorite animated:YES];
            }
                break;
            case 2:
            {
//                [self openAlbum];
            }
                break;
            default:
                break;
        }
        
    }];

}

- (void)clicked
{
//    UIView *window = self.navigationController.tabBarController.view.superview;
     UIView *window = self.navigationController.view.superview;
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat windowY = ZHScreenHeight / 2;
        CGFloat windowX = ZHScreenWidth * 0.9;
//        self.navigationController.tabBarController.view.userInteractionEnabled = NO;
        self.navigationController.view.userInteractionEnabled = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToHome:)];
        [window addGestureRecognizer:tap];
        window.center = CGPointMake(windowX, windowY);
        window.transform = CGAffineTransformScale(window.transform, 0.75, 0.8);
        
    }];
}

- (void)backToHome:(UITapGestureRecognizer *)tap
{
//    UIView *window = self.navigationController.tabBarController.view.superview;
    UIView *window = self.navigationController.view.superview;
    [UIView animateWithDuration:0.3 animations:^{
        window.center = self.view.center;
//        self.navigationController.tabBarController.view.userInteractionEnabled = YES;
        self.navigationController.view.userInteractionEnabled = YES;
        window.transform = CGAffineTransformScale(self.view.transform, 1.0, 1.0);
        window.userInteractionEnabled = YES;
        [window removeGestureRecognizer:tap];
    }];

}

- (void)platformView:(id)obj selectDirector:(PlatformViewDirector)director
{
//    NSLog(@"%ld",director);
    
    switch (director) {
        case PlatformViewDirectorUpperLeft:
        {
            RandPraticeViewController *vc = [[RandPraticeViewController alloc] init];
            vc.testType = @"rand";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case PlatformViewDirectorTopLeft:
        {
//            vc.testType = @"order";
            StatisticalResultViewController *statisticalResultVC = [[StatisticalResultViewController alloc] init];
            [self.navigationController pushViewController:statisticalResultVC animated:YES];
        }
            break;
        case PlatformViewDirectorCenter:
        {
            MokeExamViewController *mokeExamVC = [[MokeExamViewController alloc] init];
            mokeExamVC.testType = @"rand";
            [self.navigationController pushViewController:mokeExamVC animated:YES];
        }
            break;
        case PlatformViewDirectorTopRight:
        {
           
            OrderPracticeViewController *vc = [[OrderPracticeViewController alloc] init];
            vc.testType = @"order";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case PlatformViewDirectorUpperRight:
        {
            FavoriteViewController *favoritevc= [[FavoriteViewController alloc] init];
            [self.navigationController pushViewController:favoritevc animated:YES];
        }
            break;
            
        default:
        {
            ExerciseViewController *vc = [[ExerciseViewController alloc] init];
            vc.testType = @"rand";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIView *tabBarButton in self.navigationController.tabBarController.tabBar.subviews) {
        if (![tabBarButton isKindOfClass:[ZHTabbar class]]) {
            [tabBarButton removeFromSuperview];
        }
    }
}
#pragma mark 打开相册
- (void)openAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self selectImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else
    {
        NSLog(@"不支持相册");
    }

}

-(void)selectImage:(UIImagePickerControllerSourceType)type
{
    //选取图片控制器
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    
    //设置图片源
    picker.sourceType = type;
    
    //设置代理
    picker.delegate = self;
    
    //设置是否需要裁剪,多用于头像图片的选择
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)cancelAction
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    
    //找到原图:UIImagePickerControllerOriginalImage
    //裁剪之后的图片:UIImagePickerControllerEditedImage
    UIImage *img = info[UIImagePickerControllerEditedImage];
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 50, 300, 300)];
    [self.view addSubview:imgv];
    imgv.image = img;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//当实现取消的代理方法的时候,默认图片选取界面是不能返回的,必须在这个代理方法里面实现
//如果在这个方法里不需要做其它操作,这个方法不用实现
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
