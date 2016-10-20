//
//  OrderPracticeViewController.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/11.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "OrderPracticeViewController.h"

@interface OrderPracticeViewController ()

@end

@implementation OrderPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isOrder = YES;
    [self prepareData];
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
