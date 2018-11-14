//
//  WTUserPictureCell.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTUserPictureCell.h"
#import "WTUserHomeCellModel.h"

@interface WTUserPictureCell ()

@property (nonatomic, strong) UILabel *registerTimeLabel;
@property (nonatomic, strong) UILabel *latestPayTimeLabel;
@property (nonatomic, strong) UILabel *totalPayAmmountLabel;
@property (nonatomic, strong) UILabel *dayMaxAmmountLabel;
@property (nonatomic, strong) UILabel *repeatBuyNumberLabel;
@property (nonatomic, strong) UILabel *perMaxAmmountLabel;
@property (nonatomic, strong) UILabel *perOrderAmmountLabel;

@end

@implementation WTUserPictureCell

#pragma mark - Life Cycle
+ (instancetype)userPictureCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WTUserPictureCell";
    WTUserPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[WTUserPictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        for (int i = 1; i < 8; i ++)
        {
            UILabel *cellLabel = [[UILabel alloc] init];
            cellLabel.tag = i;
            cellLabel.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:cellLabel];
        }
        
        _registerTimeLabel = [self.contentView viewWithTag:1];
        _latestPayTimeLabel = [self.contentView viewWithTag:2];
        _totalPayAmmountLabel = [self.contentView viewWithTag:3];
        _dayMaxAmmountLabel = [self.contentView viewWithTag:4];
        _repeatBuyNumberLabel = [self.contentView viewWithTag:5];
        _perMaxAmmountLabel = [self.contentView viewWithTag:6];
        _perOrderAmmountLabel = [self.contentView viewWithTag:7];
    }
    return self;
}

#pragma mark - Setter Cycle
- (void)setCellModel:(WTUserHomeCellModel *)cellModel
{
    _cellModel = cellModel;
    
    _registerTimeLabel.frame = _cellModel.cellRegisterTimeFrame;
    _registerTimeLabel.text = _cellModel.cellRegisterTime;
    
    _latestPayTimeLabel.frame = _cellModel.cellLatestPayTimeFrame;
    _latestPayTimeLabel.text = _cellModel.cellLatestPayTime;
    
    _totalPayAmmountLabel.frame = _cellModel.cellTotalPayAmmountFrame;
    _totalPayAmmountLabel.text = _cellModel.cellTotalPayAmmount;
    
    _dayMaxAmmountLabel.frame = _cellModel.cellDayMaxAmmountFrame;
    _dayMaxAmmountLabel.text = _cellModel.cellDayMaxAmmount;
    
    _repeatBuyNumberLabel.frame = _cellModel.cellRepeatBuyNumberFrame;
    _repeatBuyNumberLabel.text = _cellModel.cellRepeatBuyNumber;
    
    _perMaxAmmountLabel.frame = _cellModel.cellPerMaxAmmountFrame;
    _perMaxAmmountLabel.text = _cellModel.cellPerMaxAmmount;
    
    _perOrderAmmountLabel.frame = _cellModel.cellPerOrderAmmountFrame;
    _perOrderAmmountLabel.text = _cellModel.cellPerOrderAmmount;
}

@end
