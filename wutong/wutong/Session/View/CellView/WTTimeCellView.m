//
//  WTTimeCellView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTTimeCellView.h"

@interface WTTimeCellView ()

@property (nonatomic, strong) UIImageView *timeBkgImage;

@end

@implementation WTTimeCellView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _timeBkgImage = [[UIImageView alloc] init];
        _timeBkgImage.image = [[UIImage imageNamed:@"MessageContent_TimeNodeBkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 8, 7, 8) resizingMode:UIImageResizingModeStretch];
        [self addSubview:_timeBkgImage];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_timeLabel];
    }
    return self;
}

#pragma mark - Setter Cycle
- (void)setTimeSize:(CGSize)timeSize
{
    _timeSize = timeSize;
    
    _timeBkgImage.frame = CGRectMake((CGRectGetWidth(self.frame) - _timeSize.width) * 0.5, 12, _timeSize.width + 10, 20);
    _timeLabel.frame = _timeBkgImage.frame;
}

@end
