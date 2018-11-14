//
//  WTSystemMessageCellView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/11.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTSystemMessageCellView.h"
#import "WTSystemMessageContentView.h"

@interface WTSystemMessageCellView ()

@property (nonatomic, strong) WTSystemMessageContentView *contentView;

@end

@implementation WTSystemMessageCellView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _contentView = [[WTSystemMessageContentView alloc] init];
        [self addSubview:_contentView];
    }
    return self;
}

- (void)refreshCellViewWithMessageModel:(WTMessageModel *)messageModel
{
    _contentView.frame = messageModel.systemContentViewFrame;
    _contentView.systemMessage = messageModel;
}

@end
