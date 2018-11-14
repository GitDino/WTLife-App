//
//  WTHomeToolBar.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTHomeToolBar.h"

@interface WTHomeToolBar ()

@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation WTHomeToolBar

#pragma mark - Life Cycle
+ (instancetype)homeToolBar
{
    WTHomeToolBar *toolBar = [[WTHomeToolBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    return toolBar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 60, SCREEN_WIDTH - 80, 48)];
        _sendBtn.backgroundColor = [UIColor wtAppColor];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sendBtn setTitle:@"发送消息" forState:UIControlStateNormal];
        [self addSubview:_sendBtn];
        [_sendBtn addTarget:self action:@selector(onTapSendMessage) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Event Cycle
- (void)onTapSendMessage
{
    if (self.tapSendMessageBlock)
    {
        self.tapSendMessageBlock();
    }
}

@end
