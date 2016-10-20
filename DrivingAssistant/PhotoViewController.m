//
//  PhotoViewController.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/6.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"
@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    NSURL *url = [NSURL URLWithString:self.imageUrl];
    [imageView setImageWithURL:url];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tap];
    [self.view addSubview:imageView];
    
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
