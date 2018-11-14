//
//  WTMessageCell.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTMessageCell.h"
#import "WTTimeCellView.h"
#import "WTTextMessageCellView.h"
#import "WTImageMessageCellView.h"
#import "WTAudioMessageCellView.h"
#import "WTVideoMessageCellView.h"
#import "WTChartletMessageCellView.h"
#import "WTSystemMessageCellView.h"
#import "WTGoodsMessageCellView.h"
#import "WTOrderMessageCellView.h"

#import "WTMessageModel.h"
#import "WTTimestampModel.h"

@interface WTMessageCell () <WTCommonMessageCellViewDelegate>

@property (nonatomic, strong) WTTimeCellView *timeCellView;

@property (nonatomic, strong) WTTextMessageCellView *textCellView;

@property (nonatomic, strong) WTImageMessageCellView *imageCellView;

@property (nonatomic, strong) WTAudioMessageCellView *audioCellView;

@property (nonatomic, strong) WTVideoMessageCellView *videoCellView;

@property (nonatomic, strong) WTChartletMessageCellView *chartletCellView;

@property (nonatomic, strong) WTSystemMessageCellView *systemCellView;

@property (nonatomic, strong) WTGoodsMessageCellView *goodsCellView;

@property (nonatomic, strong) WTOrderMessageCellView *orderCellView;

@end

@implementation WTMessageCell

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

+ (instancetype)messageCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WTMessageCell";
    WTMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[WTMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _timeCellView = [[WTTimeCellView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0)];
        [self.contentView addSubview:_timeCellView];
        
        _textCellView = [[WTTextMessageCellView alloc] init];
        _textCellView.delegate = self;
        [self.contentView addSubview:_textCellView];
        
        _imageCellView = [[WTImageMessageCellView alloc] init];
        _imageCellView.delegate = self;
        [self.contentView addSubview:_imageCellView];
        
        _audioCellView = [[WTAudioMessageCellView alloc] init];
        _audioCellView.delegate = self;
        [self.contentView addSubview:_audioCellView];
        
        _videoCellView = [[WTVideoMessageCellView alloc] init];
        _videoCellView.delegate = self;
        [self.contentView addSubview:_videoCellView];
        
        _chartletCellView = [[WTChartletMessageCellView alloc] init];
        _chartletCellView.delegate = self;
        [self.contentView addSubview:_chartletCellView];
        
        _systemCellView = [[WTSystemMessageCellView alloc] init];
        [self.contentView addSubview:_systemCellView];
        
        _goodsCellView = [[WTGoodsMessageCellView alloc] init];
        _goodsCellView.delegate = self;
        [self.contentView addSubview:_goodsCellView];
        
        _orderCellView = [[WTOrderMessageCellView alloc] init];
        _orderCellView.delegate = self;
        [self.contentView addSubview:_orderCellView];
    }
    return self;
}

#pragma mark - WTCommonMessageCellViewDelegate代理方法
- (void)onTapHeadIconWithSessionId:(NSString *)sessionId
{
    if ([self.delegate respondsToSelector:@selector(onTapHeadIconWithSessionId:)])
    {
        [self.delegate onTapHeadIconWithSessionId:sessionId];
    }
}

- (void)onRetryMessage:(NIMMessage *)message
{
    if ([self.delegate respondsToSelector:@selector(onRetryMessage:)])
    {
        [self.delegate onRetryMessage:self.messageModel.message];
    }
}

- (void)onDeleteMessage
{
    if ([self.delegate respondsToSelector:@selector(onDeleteMessage:)])
    {
        [self.delegate onDeleteMessage:self.messageModel.message];
    }
}

- (void)onRevokeMessage
{
    if ([self.delegate respondsToSelector:@selector(onRevokeMessage:)])
    {
        [self.delegate onRevokeMessage:self.messageModel.message];
    }
}

- (void)onTapTextMessage
{
    if ([self.delegate respondsToSelector:@selector(onTapTextMessage:)])
    {
        [self.delegate onTapTextMessage:self.messageModel.message];
    }
}

- (void)onTapImageMessageWithView:(WTBubbleImageView *)bubbleImage
{
    if ([self.delegate respondsToSelector:@selector(onTapImageMessage:bubbleImage:)])
    {
        [self.delegate onTapImageMessage:self.messageModel.message bubbleImage:bubbleImage];
    }
}

- (void)onTapAudioMessage
{
    if ([self.delegate respondsToSelector:@selector(onTapAudioMessage:)])
    {
        [self.delegate onTapAudioMessage:self.messageModel.message];
    }
}

- (void)onTapVideoMessage
{
    if ([self.delegate respondsToSelector:@selector(onTapVideoMessage:)])
    {
        [self.delegate onTapVideoMessage:self.messageModel.message];
    }
}

- (void)onTapGoodsMessage
{
    if ([self.delegate respondsToSelector:@selector(onTapGoodsMessage:)])
    {
        [self.delegate onTapGoodsMessage:self.messageModel.message];
    }
}

- (void)onTapOrderMessage
{
    if ([self.delegate respondsToSelector:@selector(onTapOrderMessage:)])
    {
        [self.delegate onTapOrderMessage:self.messageModel.message];
    }
}

#pragma mark - Setter Cycle
- (void)setTimestampModel:(WTTimestampModel *)timestampModel
{
    _timestampModel = timestampModel;
    
    _timeCellView.hidden = NO;
    _timeCellView.timeSize = _timestampModel.timeSize;
    _timeCellView.timeLabel.text = _timestampModel.timeResult;
    
    _textCellView.hidden = YES;
    _chartletCellView.hidden = YES;
    _imageCellView.hidden = YES;
    _audioCellView.hidden = YES;
    _videoCellView.hidden = YES;
    _systemCellView.hidden = YES;
    _goodsCellView.hidden = YES;
    _orderCellView.hidden = YES;
}

- (void)setMessageModel:(WTMessageModel *)messageModel
{
    _messageModel = messageModel;
    
    _timeCellView.hidden = YES;
    
    switch (_messageModel.type) {
        case MessageModelTypeText:          //文本
            _textCellView.hidden = NO;
            _textCellView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _messageModel.cellHeight);
            [_textCellView refreshCellViewWithMessageModel:_messageModel];
            _imageCellView.hidden = YES;
            _audioCellView.hidden = YES;
            _videoCellView.hidden = YES;
            _chartletCellView.hidden = YES;
            _systemCellView.hidden = YES;
            _goodsCellView.hidden = YES;
            _orderCellView.hidden = YES;
            break;
        case MessageModelTypeChartlet:      //超级表情
            _chartletCellView.hidden = NO;
            _chartletCellView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _messageModel.cellHeight);
            [_chartletCellView refreshCellViewWithMessageModel:_messageModel];
            _textCellView.hidden = YES;
            _imageCellView.hidden = YES;
            _audioCellView.hidden = YES;
            _videoCellView.hidden = YES;
            _systemCellView.hidden = YES;
            _goodsCellView.hidden = YES;
            _orderCellView.hidden = YES;
            break;
        case MessageModelTypeImage:         //图片
            _imageCellView.hidden = NO;
            _imageCellView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _messageModel.cellHeight);
            [_imageCellView refreshCellViewWithMessageModel:_messageModel];
            _textCellView.hidden = YES;
            _audioCellView.hidden = YES;
            _chartletCellView.hidden = YES;
            _videoCellView.hidden = YES;
            _systemCellView.hidden = YES;
            _goodsCellView.hidden = YES;
            _orderCellView.hidden = YES;
            break;
        case MessageModelTypeAudio:         //语音
            _audioCellView.hidden = NO;
            _audioCellView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _messageModel.cellHeight);
            [_audioCellView refreshCellViewWithMessageModel:_messageModel];
            _textCellView.hidden = YES;
            _imageCellView.hidden = YES;
            _chartletCellView.hidden = YES;
            _videoCellView.hidden = YES;
            _systemCellView.hidden = YES;
            _goodsCellView.hidden = YES;
            _orderCellView.hidden = YES;
            break;
        case MessageModelTypeVideo:         //视频
            _videoCellView.hidden = NO;
            _videoCellView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _messageModel.cellHeight);
            [_videoCellView refreshCellViewWithMessageModel:_messageModel];
            _textCellView.hidden = YES;
            _imageCellView.hidden = YES;
            _audioCellView.hidden = YES;
            _chartletCellView.hidden = YES;
            _systemCellView.hidden = YES;
            _goodsCellView.hidden = YES;
            _orderCellView.hidden = YES;
            break;
        case MessageModelTypeTip:
            _systemCellView.hidden = NO;
            _systemCellView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _messageModel.cellHeight);
            [_systemCellView refreshCellViewWithMessageModel:_messageModel];
            _textCellView.hidden = YES;
            _imageCellView.hidden = YES;
            _audioCellView.hidden = YES;
            _chartletCellView.hidden = YES;
            _videoCellView.hidden = YES;
            _goodsCellView.hidden = YES;
            _orderCellView.hidden = YES;
            break;
        case MessageModelTypeGoods:
            _goodsCellView.hidden = NO;
            _goodsCellView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _messageModel.cellHeight);
            [_goodsCellView refreshCellViewWithMessageModel:_messageModel];
            _textCellView.hidden = YES;
            _imageCellView.hidden = YES;
            _audioCellView.hidden = YES;
            _chartletCellView.hidden = YES;
            _videoCellView.hidden = YES;
            _systemCellView.hidden = YES;
            _orderCellView.hidden = YES;
            break;
        case MessageModelTypeOrder:
            _orderCellView.hidden = NO;
            _orderCellView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _messageModel.cellHeight);
            [_orderCellView refreshCellViewWithMessageModel:_messageModel];
            _textCellView.hidden = YES;
            _imageCellView.hidden = YES;
            _audioCellView.hidden = YES;
            _chartletCellView.hidden = YES;
            _videoCellView.hidden = YES;
            _systemCellView.hidden = YES;
            _goodsCellView.hidden = YES;
            break;
            
        default:
            _textCellView.hidden = YES;
            _imageCellView.hidden = YES;
            _audioCellView.hidden = YES;
            _chartletCellView.hidden = YES;
            _videoCellView.hidden = YES;
            _systemCellView.hidden = YES;
            _goodsCellView.hidden = YES;
            _orderCellView.hidden = YES;
            break;
    }
}

@end
