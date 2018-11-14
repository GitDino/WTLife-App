//
//  WTTagsView.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTTagsView.h"
#import "WTTagModel.h"
#import "WTUserHomeCellModel.h"

@implementation WTTagsView

- (void)setCellModel:(WTUserHomeCellModel *)cellModel
{
    _cellModel = cellModel;
    
    for (UILabel *tagLabel in self.subviews)
    {
        [tagLabel removeFromSuperview];
    }
    
    if (_cellModel.isSystem)
    {
        for (int i = 0; i < _cellModel.systemTagsFrameArray.count; i ++)
        {
            WTTagModel *tagModel = _cellModel.systemTagArray[i];
            UILabel *tagLabel = [[UILabel alloc] initWithFrame:[_cellModel.systemTagsFrameArray[i] CGRectValue]];
            tagLabel.textAlignment = NSTextAlignmentCenter;
            tagLabel.font = [UIFont systemFontOfSize:12];
            tagLabel.textColor = [UIColor wtBlackColor];
            tagLabel.layer.borderWidth = 1.0;
            tagLabel.layer.borderColor = [UIColor wtBlackColor].CGColor;
            tagLabel.text = tagModel.tagName;
            [self addSubview:tagLabel];
        }
    }
    else
    {
        for (int i = 0; i < _cellModel.customTagsFrameArray.count; i ++)
        {
            WTTagModel *tagModel = _cellModel.customTagArray[i];
            UILabel *tagLabel = [[UILabel alloc] initWithFrame:[_cellModel.customTagsFrameArray[i] CGRectValue]];
            tagLabel.textAlignment = NSTextAlignmentCenter;
            tagLabel.font = [UIFont systemFontOfSize:12];
            tagLabel.textColor = [UIColor wtBlackColor];
            tagLabel.layer.borderWidth = 1.0;
            tagLabel.layer.borderColor = [UIColor wtBlackColor].CGColor;
            tagLabel.text = tagModel.tagName;
            [self addSubview:tagLabel];
        }
    }
}

@end
