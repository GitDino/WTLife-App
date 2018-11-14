//
//  WTUserOrderCell.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTUserOrderCell.h"
#import "WTUserHomeCellModel.h"

@interface WTUserOrderCell ()

@property (nonatomic, strong) UILabel *orderTimeLabel;
@property (nonatomic, strong) UILabel *orderInfoLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *goodsSKULabel;
@property (nonatomic, strong) UILabel *goodsAmmountLabel;
@property (nonatomic, strong) UILabel *goodsNumberLabel;

@end

@implementation WTUserOrderCell

#pragma mark - Life Cycle
+ (instancetype)userOrderCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WTUserOrderCell";
    WTUserOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[WTUserOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _orderTimeLabel = [[UILabel alloc] init];
        _orderTimeLabel.font = [UIFont systemFontOfSize:12];
        _orderTimeLabel.textColor = [UIColor wtBlackColor];
        [self.contentView addSubview:_orderTimeLabel];
        
        _orderInfoLabel = [[UILabel alloc] init];
        _orderInfoLabel.textAlignment = NSTextAlignmentRight;
        _orderInfoLabel.font = [UIFont systemFontOfSize:12];
        _orderInfoLabel.textColor = [UIColor wtBlackColor];
        [self.contentView addSubview:_orderInfoLabel];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor wtLightGrayColor];
        [self.contentView addSubview:_lineView];
        
        _goodsImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_goodsImage];
        
        _goodsNameLabel = [[UILabel alloc] init];
        _goodsNameLabel.numberOfLines = 2;
        _goodsNameLabel.font = [UIFont systemFontOfSize:12];
        _goodsNameLabel.textColor = [UIColor wtBlackColor];
        [self.contentView addSubview:_goodsNameLabel];
        
        _goodsSKULabel = [[UILabel alloc] init];
        _goodsSKULabel.font = [UIFont systemFontOfSize:12];
        _goodsSKULabel.textColor = [UIColor wtBlackColor];
        [self.contentView addSubview:_goodsSKULabel];
        
        _goodsAmmountLabel = [[UILabel alloc] init];
        _goodsAmmountLabel.font = [UIFont systemFontOfSize:14];
        _goodsAmmountLabel.textColor = [UIColor wtBlackColor];
        [self.contentView addSubview:_goodsAmmountLabel];
        
        _goodsNumberLabel = [[UILabel alloc] init];
        _goodsNumberLabel.textAlignment = NSTextAlignmentRight;
        _goodsNumberLabel.font = [UIFont systemFontOfSize:14];
        _goodsNumberLabel.textColor = [UIColor wtBlackColor];
        [self.contentView addSubview:_goodsNumberLabel];
    }
    return self;
}

- (void)setCellModel:(WTUserHomeCellModel *)cellModel
{
    _cellModel = cellModel;
    
    _orderTimeLabel.frame = _cellModel.cellOrderTimeFrmae;
    _orderTimeLabel.text = _cellModel.cellOrderTime;
    
    _orderInfoLabel.frame = _cellModel.cellOrderInfoFrame;
    _orderInfoLabel.text = _cellModel.cellOrderInfo;
    
    _lineView.frame = _cellModel.lineViewFrame;
    
    _goodsImage.frame = _cellModel.cellGoodsImageFrame;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_cellModel.cellGoodsImage] placeholderImage:nil];
    
    _goodsNameLabel.frame = _cellModel.cellGoodsNameFrame;
    _goodsNameLabel.text = _cellModel.cellGoodsName;
    
    _goodsSKULabel.frame = _cellModel.cellGoodsSKUFrame;
    _goodsSKULabel.text = _cellModel.cellGoodsSKU;
    
    _goodsAmmountLabel.frame = _cellModel.cellGoodsAmmountFrame;
    _goodsAmmountLabel.text = _cellModel.cellGoodsAmmount;
    
    _goodsNumberLabel.frame = _cellModel.cellGoodsNumberFrame;
    _goodsNumberLabel.text = _cellModel.cellGoodsNumber;
}

@end
