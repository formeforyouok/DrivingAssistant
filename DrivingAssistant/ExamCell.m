//
//  ExamCell.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/5.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ExamCell.h"
@interface ExamCell()
{
    UIImageView *_imageView;
    UILabel *_itemLabel;
}
@end


@implementation ExamCell

- (void)awakeFromNib {
    // Initialization code
}

+ (ExamCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellid = @"cellid";
    ExamCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ExamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
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
    _imageView.frame = CGRectMake(10, 10, 39, 39);
    [self.contentView addSubview:_imageView];
    _itemLabel = [[UILabel alloc] init];
    _itemLabel.frame = CGRectMake(60, 5,ZHScreenWidth - 60 , 50);
//    _itemLabel.adjustsFontSizeToFitWidth = YES;
    _itemLabel.numberOfLines = 0;
    _itemLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_itemLabel];
}

- (void)setModel:(ItemModel *)model
{
    _model = model;
    switch (model.status) {
        case ItemStatusNormal:
        {
            _imageView.image = [UIImage imageNamed:_model.imageName];
        }
            break;
        case ItemStatusSelected:
        {
            _imageView.image = [UIImage imageNamed:_model.imageSelectedName];
        }
            break;
        case ItemStatusError:
        {
            _imageView.image = [UIImage imageNamed:_model.imageErrorName];
        }
            break;
        case ItemStatusRight:
        {
            _imageView.image = [UIImage imageNamed:_model.imageRightName];
        }
            break;
        default:
            break;
    }
    _itemLabel.text = _model.item;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
