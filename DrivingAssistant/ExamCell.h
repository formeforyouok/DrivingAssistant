//
//  ExamCell.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/5.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"
@interface ExamCell : UITableViewCell

+ (ExamCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,retain) ItemModel *model;

@end
