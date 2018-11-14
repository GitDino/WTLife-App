//
//  WTSystemMessageContentView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/11.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTSystemMessageContentView.h"
#import "WTMessageModel.h"

@interface WTSystemMessageContentView ()

@property (nonatomic, strong) UIImageView *systemImage;

@property (nonatomic, strong) UILabel *systemLabel;

@end

@implementation WTSystemMessageContentView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _systemImage = [[UIImageView alloc] init];
        _systemImage.image = [[UIImage imageNamed:@"MessageContent_TimeNodeBkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 8, 7, 8) resizingMode:UIImageResizingModeStretch];
        [self addSubview:_systemImage];
        
        _systemLabel = [[UILabel alloc] init];
        _systemLabel.font = [UIFont systemFontOfSize:14];
        _systemLabel.textAlignment = NSTextAlignmentCenter;
        _systemLabel.textColor = [UIColor whiteColor];
        [self addSubview:_systemLabel];
    }
    return self;
}

#pragma mark - Setter Cycle
- (void)setSystemMessage:(WTMessageModel *)systemMessage
{
    _systemMessage = systemMessage;
    
    NIMMessage *tipMessage = _systemMessage.message;
    
    _systemImage.frame = systemMessage.tipImageFrame;
    
    _systemLabel.frame = systemMessage.tipFrame;
    _systemLabel.text = tipMessage.text;
}

@end
