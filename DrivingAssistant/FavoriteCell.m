//
//  FavoriteCell.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/14.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "FavoriteCell.h"
#import "UIImageView+WebCache.h"
@interface FavoriteCell()
{
    UIImageView *_imageView;
    UILabel *_questionLabel;
}

@end

@implementation FavoriteCell

- (void)awakeFromNib {
    // Initialization code
}

+ (FavoriteCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellid = @"cellid";
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[FavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(10, 10, 100, 100);
    [self.contentView addSubview:_imageView];
    _questionLabel = [[UILabel alloc] init];
    _questionLabel.frame = CGRectMake(120, 10,ZHScreenWidth - 120 , 100);
    //    _itemLabel.adjustsFontSizeToFitWidth = YES;
    _questionLabel.numberOfLines = 0;
    _questionLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_questionLabel];

}

- (void)setModel:(ExerciseModel *)model
{
    _model = model;
    
    [_imageView setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    _questionLabel.text = model.question;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
