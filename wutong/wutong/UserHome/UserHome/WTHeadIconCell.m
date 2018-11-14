//
//  WTHeadIconCell.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTHeadIconCell.h"
#import "WTUserHomeCellModel.h"

@interface WTHeadIconCell ()

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *sexImage;

@property (nonatomic, strong) UILabel *placeholerLabel;

@end

@implementation WTHeadIconCell

+ (instancetype)headIconCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WTHeadIconCell";
    WTHeadIconCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[WTHeadIconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.contentMode = UIViewContentModeScaleAspectFill;
        _iconImage.clipsToBounds = YES;
        _iconImage.layer.cornerRadius = 5.0;
        [self.contentView addSubview:_iconImage];
        
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        
        
        _sexImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_sexImage];
        
//        for (int i = 0; i < 5; i ++)
//        {
//            UIImageView *startImage = [[UIImageView alloc] init];
//            startImage.tag = i + 1;
//            startImage.image = [UIImage imageNamed:@"icon_judge_start"];
//            [self.contentView addSubview:startImage];
//        }
        
        _placeholerLabel = [[UILabel alloc] init];
        _placeholerLabel.font = [UIFont systemFontOfSize:12];
        _placeholerLabel.numberOfLines = 0;
        [self.contentView addSubview:_placeholerLabel];
    }
    return self;
}

#pragma mark - Setter Cycle
- (void)setCellModel:(WTUserHomeCellModel *)cellModel
{
    _cellModel = cellModel;
    
    _iconImage.frame = _cellModel.iconFrame;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_cellModel.cellIcon] placeholderImage:[UIImage imageNamed:@"icon_default_head"]];
    
    _nameLabel.frame = _cellModel.nameFrame;
    _nameLabel.text = _cellModel.cellName;
    
    _sexImage.frame = _cellModel.sexFrame;
    _sexImage.image = _cellModel.cellSex == 1 ? [UIImage imageNamed:@"icon_boy"] : [UIImage imageNamed:@"icon_girl"];
    
//    for (int i = 0; i < _cellModel.startsFrameArray.count; i ++)
//    {
//        UIImageView *startImage = (UIImageView *)[self.contentView viewWithTag:i + 1];
//        startImage.frame = [_cellModel.startsFrameArray[i] CGRectValue];
//    }

    _placeholerLabel.frame = _cellModel.placeholderFrame;
    _placeholerLabel.text = _cellModel.cellPlaceholer;
}

@end
