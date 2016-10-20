//
//  StatisticalCell.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/11.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatisticalModel.h"
@interface StatisticalCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) UILabel *scoreLabel;

@property (nonatomic,strong) UILabel *currentDateLabel;

@property (nonatomic,strong) StatisticalModel *model;

@end
