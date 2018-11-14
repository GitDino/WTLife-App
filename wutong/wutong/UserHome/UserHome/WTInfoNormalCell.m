//
//  WTInfoNormalCell.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTInfoNormalCell.h"
#import "WTUserHomeCellModel.h"

@interface WTInfoNormalCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation WTInfoNormalCell

+ (instancetype)infoNormalCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WTInfoNormalCell";
    WTInfoNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[WTInfoNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor wtBlackColor];
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = [UIColor wtColorWithR:146 G:146 B:146 A:1.0];
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

#pragma mark - Setter Cycle
- (void)setCellModel:(WTUserHomeCellModel *)cellModel
{
    _cellModel = cellModel;
    
    _titleLabel.frame = _cellModel.titleFrame;
    _titleLabel.text = _cellModel.cellTitle;
    
    _contentLabel.frame = _cellModel.contentFrame;
    _contentLabel.text = _cellModel.cellContent;
}

@end
