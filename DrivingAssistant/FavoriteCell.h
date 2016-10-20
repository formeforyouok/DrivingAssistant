//
//  FavoriteCell.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/14.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ExerciseModel.h"
@interface FavoriteCell : UITableViewCell

+ (FavoriteCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,retain) ExerciseModel *model;

@end
