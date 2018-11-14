//
//  WTMessageModel.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTMessageModel.h"
#import "WTChartletModel.h"
#import "WTChatGoodsModel.h"
#import "WTChatOrderModel.h"
#import <M80AttributedLabel.h>
#import "M80AttributedLabel+WT.h"
#import "WTSessionUtil.h"
#import <UIImage+IM.h>

@interface WTMessageModel ()

@property (nonatomic, strong) M80AttributedLabel *textLabel;

@end

@implementation WTMessageModel

#pragma mark - Public Cycle
- (instancetype)initWithMessage:(NIMMessage *)message
{
    if (self = [super init])
    {
        _textLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = [UIFont fontWithName:@"SFUIText-Bold" size:17];
        
        _message = message;
        
        switch (_message.messageType) {
            case NIMMessageTypeText:
                _type = MessageModelTypeText;
                break;
            case NIMMessageTypeImage:
                _type = MessageModelTypeImage;
                break;
            case NIMMessageTypeAudio:
            {
                _type = MessageModelTypeAudio;
                NIMAudioObject *audioObject = (NIMAudioObject *)_message.messageObject;
                _audioDuration = [NSString stringWithFormat:@"%.0f''", audioObject.duration / 1000.0];
            }
                break;
            case NIMMessageTypeVideo:
            {
                _type = MessageModelTypeVideo;
                NIMVideoObject *videoObject = (NIMVideoObject *)_message.messageObject;
                _videoDuration = [NSString stringWithFormat:@"0:%02.0f", videoObject.duration / 1000.0];
            }
                break;
            case NIMMessageTypeTip:
                _type = MessageModelTypeTip;
                break;
            case NIMMessageTypeCustom:
            {
                NIMCustomObject *customObject = (NIMCustomObject*)self.message.messageObject;
                if ([customObject.attachment class] == [WTChartletModel class])
                {
                    _type = MessageModelTypeChartlet;
                    _chartletModel = (WTChartletModel *)customObject.attachment;
                }
                else if ([customObject.attachment class] == [WTChatGoodsModel class])
                {
                    _type = MessageModelTypeGoods;
                    _goodsModel = (WTChatGoodsModel *)customObject.attachment;
                }
                else if ([customObject.attachment class] == [WTChatOrderModel class])
                {
                    _type = MessageModelTypeOrder;
                    _orderModel = (WTChatOrderModel *)customObject.attachment;
                }
            }
                break;
                
            default:
                break;
        }
        
        [self configAboutRect];
    }
    return self;
}

#pragma mark - Private Cycle
- (void)configAboutRect
{
    //头像
    _iconFrame = !self.message.isOutgoingMsg ? CGRectMake(10, 2, 40, 40) : CGRectMake(SCREEN_WIDTH - 10 - 40, 2, 40, 40);
    
    
    switch (_type) {
        case MessageModelTypeText:      //文字
        {
            [self.textLabel wt_setText:self.message.text];
            //修改M80库
            CGSize textSize = [self.textLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 140, MAXFLOAT)];
            
            CGFloat textX = !self.message.isOutgoingMsg ? CGRectGetMaxX(_iconFrame) + 10 : CGRectGetMinX(_iconFrame) - 10 - textSize.width - 20;
            
            _textContentViewFrame = CGRectMake(textX, CGRectGetMinY(_iconFrame), textSize.width + 20, textSize.height + 18);
            
            _textFrame = CGRectMake(10, 9, textSize.width, textSize.height);
            
            _textBubbleFrame = CGRectMake(-5, -2, textSize.width + 30, CGRectGetHeight(_textContentViewFrame) + 9);
            
            _activityFrame = self.message.isOutgoingMsg ? CGRectMake(CGRectGetMinX(_textContentViewFrame) - 25, 12, 20, 20) : CGRectZero;
            _failBtnFrame = self.message.isOutgoingMsg ? CGRectMake(CGRectGetMinX(_textContentViewFrame) - 27, 11, 22, 22) : CGRectZero;
            
            _cellHeight = CGRectGetHeight(_textContentViewFrame) + 12;
        }
            break;
        case MessageModelTypeImage:     //图片
        {
            CGSize imageSize = [WTSessionUtil contentSizeWithMessage:self.message];
            
            _imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
            
            _imageContentViewFrame = !self.message.isOutgoingMsg ? CGRectMake(CGRectGetMaxX(_iconFrame) + 10, CGRectGetMinY(_iconFrame), imageSize.width, imageSize.height) : CGRectMake(CGRectGetMinX(_iconFrame) - 10 - imageSize.width, CGRectGetMinY(_iconFrame), imageSize.width, imageSize.height);
            
            _activityFrame = self.message.isOutgoingMsg ? CGRectMake(CGRectGetMinX(_imageContentViewFrame) - 25, (imageSize.height - 20) * 0.5 + CGRectGetMinY(_iconFrame), 20, 20) : CGRectMake(CGRectGetMaxX(_imageContentViewFrame) + 5, (imageSize.height - 20) * 0.5 + CGRectGetMinY(_iconFrame), 20, 20);
            _failBtnFrame = self.message.isOutgoingMsg ? CGRectMake(CGRectGetMinX(_imageContentViewFrame) - 27, (imageSize.height - 22) * 0.5 + CGRectGetMinY(_iconFrame), 22, 22) : CGRectMake(CGRectGetMaxX(_imageContentViewFrame) + 5, (imageSize.height - 22) * 0.5 + CGRectGetMinY(_iconFrame), 22, 22);
            
            _cellHeight = CGRectGetHeight(_imageContentViewFrame) + 12;
        }
            break;
        case MessageModelTypeAudio:     //语音
        {
            CGSize audioSize = [WTSessionUtil matchAudioDuration:self.message];
            
            CGFloat audioX = !self.message.isOutgoingMsg ? CGRectGetMaxX(_iconFrame) + 10 : CGRectGetMinX(_iconFrame) - 10 - audioSize.width;
            
            _audioContentViewFrame = CGRectMake(audioX, CGRectGetMinY(_iconFrame), audioSize.width, audioSize.height);
            
            _audioBubbleFrame = CGRectMake(-5, -2, audioSize.width + 10, audioSize.height + 9);
            
            
            CGSize durationSize = [NSString sizeWithText:self.audioDuration font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            CGFloat durationX = !self.message.isOutgoingMsg ? CGRectGetMaxX(_audioBubbleFrame) : CGRectGetMinX(_audioBubbleFrame) - durationSize.width;
            _durationFrame = CGRectMake(durationX, 17, durationSize.width, 17);
            
            
            CGFloat animationX = !self.message.isOutgoingMsg ? 10 : CGRectGetWidth(_audioContentViewFrame) - 10 - 12.5;
            _animationFrame = CGRectMake(animationX, 11.5, 12.5, 17);
            
        
            _redFrame = !self.message.isOutgoingMsg ? CGRectMake(CGRectGetMaxX(_audioBubbleFrame), 0, 8, 8) : CGRectZero;
            
            
            _activityFrame = self.message.isOutgoingMsg ? CGRectMake(CGRectGetMinX(_audioContentViewFrame) - 25, (audioSize.height - 20) * 0.5 + CGRectGetMinY(_iconFrame), 20, 20) : CGRectMake(CGRectGetMaxX(_audioContentViewFrame) + 5, (audioSize.height - 20) * 0.5 + CGRectGetMinY(_iconFrame), 20, 20);
            _failBtnFrame = self.message.isOutgoingMsg ? CGRectMake(CGRectGetMinX(_audioContentViewFrame) - 27, (audioSize.height - 22) * 0.5 + CGRectGetMinY(_iconFrame), 22, 22) : CGRectMake(CGRectGetMaxX(_audioContentViewFrame) + 5, (audioSize.height - 22) * 0.5 + CGRectGetMinY(_iconFrame), 22, 22);

            
            _cellHeight = CGRectGetHeight(_audioContentViewFrame) + 12;
        }
            break;
        case MessageModelTypeVideo:     //视频
        {
            CGSize videoSize = [WTSessionUtil contentSizeWithMessage:self.message];
            
            _videoImageFrame = CGRectMake(0, 0, videoSize.width, videoSize.height);
            
            _playImageFrame = CGRectMake((videoSize.width - 41) * 0.5, (videoSize.height - 41) * 0.5, 41, 41);
            
            _shadowImageFrame = CGRectMake(0, videoSize.height - 21, videoSize.width, 20);
            
            _timeLabelFrame = CGRectMake(7, 4, videoSize.width - 14, 12);
            
            _videoContentViewFrame = !self.message.isOutgoingMsg ? CGRectMake(CGRectGetMaxX(_iconFrame) + 10, CGRectGetMinY(_iconFrame), videoSize.width, videoSize.height) : CGRectMake(CGRectGetMinX(_iconFrame) - 10 - videoSize.width, CGRectGetMinY(_iconFrame), videoSize.width, videoSize.height);
            
            _activityFrame = self.message.isOutgoingMsg ? CGRectMake(CGRectGetMinX(_videoContentViewFrame) - 25, (videoSize.height - 20) * 0.5 + CGRectGetMinY(_iconFrame), 20, 20) : CGRectMake(CGRectGetMaxX(_videoContentViewFrame) + 5, (videoSize.height - 20) * 0.5 + CGRectGetMinY(_iconFrame), 20, 20);
            _failBtnFrame = self.message.isOutgoingMsg ? CGRectMake(CGRectGetMinX(_videoContentViewFrame) - 27, (videoSize.height - 22) * 0.5 + CGRectGetMinY(_iconFrame), 22, 22) : CGRectMake(CGRectGetMaxX(_videoContentViewFrame) + 5, (videoSize.height - 22) * 0.5 + CGRectGetMinY(_iconFrame), 22, 22);
            
            _cellHeight = CGRectGetHeight(_videoContentViewFrame) + 12;
        }
            break;
        case MessageModelTypeChartlet:  //超级表情
        {
            CGSize chartletSize = [[UIImage wt_fetchChartlet:self.chartletModel.chartletID chartletId:self.chartletModel.chartletCatalog] size];
            
            _chartletFrame = CGRectMake(0, 0, chartletSize.width, chartletSize.height);
            
            CGFloat chartletContentX = !self.message.isOutgoingMsg ? CGRectGetMaxX(_iconFrame) + 10 : CGRectGetMinX(_iconFrame) - 10 - chartletSize.width;
            _chartletContentViewFrame = CGRectMake(chartletContentX, CGRectGetMinY(_iconFrame), chartletSize.width, chartletSize.height);
            
            _activityFrame = self.message.isOutgoingMsg ? CGRectMake(CGRectGetMinX(_imageContentViewFrame) - 25, (chartletSize.height - 20) * 0.5 + CGRectGetMinY(_iconFrame), 20, 20) : CGRectZero;
            _failBtnFrame = self.message.isOutgoingMsg ? CGRectMake(CGRectGetMinX(_imageContentViewFrame) - 27, (chartletSize.height - 22) * 0.5 + CGRectGetMinY(_iconFrame), 22, 22) : CGRectZero;
            
            _cellHeight = CGRectGetHeight(_chartletContentViewFrame) + 12;
            
        }
            break;
        case MessageModelTypeTip:
        {
            CGSize tipSize = [NSString sizeWithText:self.message.text font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            
            _tipFrame = CGRectMake((SCREEN_WIDTH - tipSize.width) * 0.5, 3, tipSize.width, tipSize.height);
            
            _tipImageFrame = CGRectMake(CGRectGetMinX(_tipFrame) - 10, 0, tipSize.width + 20, tipSize.height + 6);
            
            _systemContentViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(_tipImageFrame));
            
            _cellHeight = CGRectGetMaxY(_systemContentViewFrame) + 12;
        }
            break;
        case MessageModelTypeGoods:     //商品
        {
            _goodContentViewFrame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 105);
            
            _goodImgFrame = CGRectMake(15, 15, 75, 75);
            
            CGSize goodsNameSize = [NSString sizeWithText:self.goodsModel.goodName font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGRectGetWidth(_goodContentViewFrame) - 115, CGRectGetHeight(_goodContentViewFrame) - 56)];
            _goodNameFrame = CGRectMake(CGRectGetMaxX(_goodImgFrame) + 10, 15, goodsNameSize.width, goodsNameSize.height);
            
            _goodPriceFrame = CGRectMake(CGRectGetMinX(_goodNameFrame), CGRectGetMaxY(_goodImgFrame) - 16, SCREEN_WIDTH - 151, 16);
            
            _cellHeight = CGRectGetMaxY(_goodContentViewFrame) + 12;
        }
            break;
        case MessageModelTypeOrder:     //订单
        {
            _orderContentViewFrame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 178);
            
            _orderTime = [WTSessionUtil showTime:_orderModel.orderTime / 1000 detail:YES];
            CGSize timeSize = [NSString sizeWithText:_orderTime font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            _orderTimeFrame = CGRectMake(CGRectGetWidth(_orderContentViewFrame) - timeSize.width - 15, 15, timeSize.width, 17);
            
            NSString *orderMoney = [NSString stringWithFormat:@"订单金额：¥%.2f", _orderModel.orderPrice];
            CGSize moneySize = [NSString sizeWithText:orderMoney font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            _orderMoneyFrame = CGRectMake(CGRectGetWidth(_orderContentViewFrame) - moneySize.width - 15, CGRectGetMaxY(_orderTimeFrame) + 8, moneySize.width, 17);
            
            _orderNo = [NSString stringWithFormat:@"所属订单：%@", _orderModel.orderNo];
            CGSize typeSize = [NSString sizeWithText:_orderNo font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGRectGetWidth(_orderContentViewFrame) - 40 - timeSize.width, MAXFLOAT)];
            _orderNoFrame = CGRectMake(15, 15, typeSize.width, 17);
            
            _orderState = [WTSessionUtil matchOrderState:_orderModel.orderState];
            CGSize stateSize = [NSString sizeWithText:_orderState font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGRectGetWidth(_orderContentViewFrame) - 40 - moneySize.width, MAXFLOAT)];
            _orderStateFrame = CGRectMake(CGRectGetMinX(_orderNoFrame), CGRectGetMaxY(_orderNoFrame) + 8, stateSize.width, 17);
            
            _orderLineViewFrame = CGRectMake(0, CGRectGetMaxY(_orderStateFrame) + 15, CGRectGetWidth(_orderContentViewFrame), 1.0);
            
            
            _goodImgFrame = CGRectMake(CGRectGetMinX(_orderNoFrame), CGRectGetMaxY(_orderLineViewFrame) + 15, 75, 75);
            
            CGSize goodsNameSize = [NSString sizeWithText:self.orderModel.goodsName font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(CGRectGetWidth(_orderContentViewFrame) - 115, CGRectGetHeight(_goodImgFrame) - 16 - 10)];
            _goodNameFrame = CGRectMake(CGRectGetMaxX(_goodImgFrame) + 10, CGRectGetMinY(_goodImgFrame), goodsNameSize.width, goodsNameSize.height);
            
            _goodPriceFrame = CGRectMake(CGRectGetMinX(_goodNameFrame), CGRectGetMaxY(_goodImgFrame) - 16, SCREEN_WIDTH - 151, 16);
            
            _cellHeight = CGRectGetMaxY(_orderContentViewFrame) + 12;
        }
            break;
            
        default:
            break;
    }
    
    
}

@end
