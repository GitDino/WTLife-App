//
//  WTCommonMessageCellView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTCommonMessageCellView.h"
#import "WTIMKit.h"

@interface WTCommonMessageCellView ()

@property (nonatomic, strong) WTIMInfo *userInfo;

/**
 头像
 */
@property (nonatomic, strong) UIImageView *iconImage;

/**
 菊花
 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;

/**
 失败按钮
 */
@property (nonatomic, strong) UIButton *failBtn;

@end

@implementation WTCommonMessageCellView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.userInteractionEnabled = YES;
        [self addSubview:_iconImage];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapHeadIcon)];
        [_iconImage addGestureRecognizer:tap];
        
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activity];
        
        _failBtn = [[UIButton alloc] init];
        [_failBtn setImage:[UIImage imageNamed:@"MessageSendFail"] forState:UIControlStateNormal];
        [_failBtn setImage:[UIImage imageNamed:@"MessageSendFail_HL"] forState:UIControlStateHighlighted];
        [self addSubview:_failBtn];
        [_failBtn addTarget:self action:@selector(onRetryMessage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Event Cycle
- (void)onRetryMessage:(NIMMessage *)message
{
    if ([self.delegate respondsToSelector:@selector(onRetryMessage:)])
    {
        [self.delegate onRetryMessage:nil];
    }
}

- (void)onTapHeadIcon
{
    if ([self.delegate respondsToSelector:@selector(onTapHeadIconWithSessionId:)])
    {
        [self.delegate onTapHeadIconWithSessionId:self.messageModel.message.from];
    }
}

#pragma mark - Public Cycle
- (void)refreshCellViewWithMessageModel:(WTMessageModel *)messageModel
{
    _messageModel = messageModel;
    
    _userInfo = [[WTIMKit sharedKit] infoByUser:messageModel.message.from session:_messageModel.message.session];
    
    _iconImage.frame = _messageModel.iconFrame;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatarURL] placeholderImage:[UIImage imageNamed:@"icon_default_head"]];
    
    _activity.frame = _messageModel.activityFrame;
    _failBtn.frame = _messageModel.failBtnFrame;
    
    switch (_messageModel.type) {
        case MessageModelTypeGoods:
        case MessageModelTypeOrder:
            _iconImage.hidden = YES;
            _activity.hidden = YES;
            _failBtn.hidden = YES;
            break;
            
        default:
        {
            if (_messageModel.message.isOutgoingMsg)
            {   //发送
                switch (_messageModel.message.deliveryState) {
                    case NIMMessageDeliveryStateDelivering:  //发送中
                        _activity.hidden = NO;
                        [_activity startAnimating];
                        _failBtn.hidden = YES;
                        break;
                    case NIMMessageDeliveryStateFailed:      //发送失败
                        _activity.hidden = YES;
                        [_activity stopAnimating];
                        _failBtn.hidden = NO;
                        break;
                        
                    default:                                 //发送成功
                        _activity.hidden = YES;
                        [_activity stopAnimating];
                        _failBtn.hidden = YES;
                        break;
                }
            }
            else
            {   //接收
                switch (_messageModel.message.attachmentDownloadState) {
                    case NIMMessageAttachmentDownloadStateDownloading:      //下载中
                        _activity.hidden = NO;
                        [_activity startAnimating];
                        _failBtn.hidden = YES;
                        break;
                    case NIMMessageAttachmentDownloadStateDownloaded:      //下载完成
                        _activity.hidden = YES;
                        [_activity stopAnimating];
                        _failBtn.hidden = YES;
                        break;
                        
                    default:
                        _activity.hidden = YES;
                        [_activity stopAnimating];
                        _failBtn.hidden = NO;
                        break;
                }
            }
        }
            break;
    }
}

@end
