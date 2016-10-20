//
//  StatisticalCell.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/11.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "StatisticalCell.h"

@implementation StatisticalCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellid = @"cellid";
    StatisticalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[StatisticalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.frame = CGRectMake(10, 0, self.contentView.width, 20);
    [self.contentView addSubview:_scoreLabel];
    
    _currentDateLabel =  [[UILabel alloc] init];
    _currentDateLabel.frame = CGRectMake(10, 25, self.contentView.width, 20);
    [self.contentView addSubview:_currentDateLabel];
}

- (void)setModel:(StatisticalModel *)model
{
    _model = model;
    _scoreLabel.text = [NSString stringWithFormat:@"%@分",model.score];
    _currentDateLabel.text = model.currentDate;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
