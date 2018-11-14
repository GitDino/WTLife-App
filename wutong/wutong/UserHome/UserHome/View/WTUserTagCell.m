//
//  WTUserTagCell.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTUserTagCell.h"
#import "WTUserHomeCellModel.h"
#import "WTTagsView.h"

@interface WTUserTagCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) WTTagsView *tagsView;

@property (nonatomic, strong) UIButton *addTagBtn;

@end

@implementation WTUserTagCell

#pragma mark - Life Cycle
+ (instancetype)userTagCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WTUserTagCell";
    WTUserTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[WTUserTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_titleLabel];
        
        _tagsView = [[WTTagsView alloc] init];
        [self.contentView addSubview:_tagsView];
        
        _addTagBtn = [[UIButton alloc] init];
        _addTagBtn.hidden = YES;
        _addTagBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_addTagBtn setTitleColor:[UIColor wtBlackColor] forState:UIControlStateNormal];
        [_addTagBtn setTitle:@"+新增标签" forState:UIControlStateNormal];
        [self.contentView addSubview:_addTagBtn];
        [_addTagBtn addTarget:self action:@selector(onTapAddCustomTagAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Event Cycle
- (void)onTapAddCustomTagAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(addCustomTag)])
    {
        [self.delegate addCustomTag];
    }
}

#pragma mark - Setter Cycle
- (void)setCellModel:(WTUserHomeCellModel *)cellModel
{
    _cellModel = cellModel;
    
    _addTagBtn.hidden = _cellModel.isSystem;
    _addTagBtn.frame = _cellModel.addCustomTagBtnFrame;
    
    if (_cellModel.isSystem)
    {
        _titleLabel.frame = _cellModel.cellSystemTitleFrame;
        _titleLabel.text = _cellModel.cellSystemTitle;
        
        _tagsView.frame = _cellModel.systemTagViewFrame;
    }
    else
    {
        _titleLabel.frame = _cellModel.cellCustomTitleFrame;
        _titleLabel.text = _cellModel.cellCustomTitle;
        
        _tagsView.frame = _cellModel.customTagViewFrame;
    }
    
    _tagsView.cellModel = _cellModel;
}

@end
