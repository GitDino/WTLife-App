//
//  WTSessionUtil.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/6/28.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#import "WTSessionUtil.h"
#import "WTChartletModel.h"
#import "WTChatGoodsModel.h"
#import "WTChatOrderModel.h"
#import "WTIMKit.h"

double OnedayTimeIntervalValue = 24 * 60 * 60;

@implementation WTSessionUtil

+ (NIMMessage *)configTipMessage:(NSString *)tip
{
    NIMMessage *message = [[NIMMessage alloc] init];
    NIMTipObject *tipObject = [[NIMTipObject alloc] init];
    message.messageObject = tipObject;
    message.text = tip;
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled = NO;
    setting.shouldBeCounted = NO;
    message.setting = setting;
    return message;
}

#pragma mark - 日期显示
+ (NSString *)showTime:(NSTimeInterval)lastTime detail:(BOOL)showDetail
{
    NSDate *nowDate = [NSDate date];
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:lastTime];
    NSString *result = nil;
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];
    
    NSInteger hour = msgDateComponents.hour;
    
    result = [WTSessionUtil getPeriodOfTime:hour withMinute:msgDateComponents.minute];
    if (hour > 12)
    {
        hour = hour - 12;
    }
    if(nowDateComponents.day == msgDateComponents.day)
    {
        result = [[NSString alloc] initWithFormat:@"%@%zd:%02d", result ,hour, (int)msgDateComponents.minute];
    }
    else if(nowDateComponents.day == (msgDateComponents.day + 1))
    {
        result = showDetail ? [[NSString alloc] initWithFormat:@"昨天 %@%zd:%02d", result, hour, (int)msgDateComponents.minute] : @"昨天";
    }
    else if(nowDateComponents.day == (msgDateComponents.day + 2))
    {
        result = showDetail ? [[NSString alloc] initWithFormat:@"前天 %@%zd:%02d", result, hour, (int)msgDateComponents.minute] : @"前天";
    }
    else if([nowDate timeIntervalSinceDate:msgDate] < 7 * OnedayTimeIntervalValue)
    {
        NSString *weekDay = [WTSessionUtil weekdayStr:msgDateComponents.weekday];
        result = showDetail ? [weekDay stringByAppendingFormat:@" %@%zd:%02d", result, hour, (int)msgDateComponents.minute] : weekDay;
    }
    else//显示日期
    {
        NSString *day = [NSString stringWithFormat:@"%zd-%zd-%zd", msgDateComponents.year, msgDateComponents.month, msgDateComponents.day];
        result = showDetail ? [day stringByAppendingFormat:@" %@%zd:%02d",result,hour,(int)msgDateComponents.minute] : day;
    }
    return result;
}

+ (NSString *)getPeriodOfTime:(NSInteger)time withMinute:(NSInteger)minute
{
    NSInteger totalMin = time * 60 + minute;
    NSString *showPeriodOfTime = @"";
    if (totalMin > 0 && totalMin <= 5 * 60)
    {
        showPeriodOfTime = @"凌晨";
    }
    else if (totalMin > 5 * 60 && totalMin < 12 * 60)
    {
        showPeriodOfTime = @"上午";
    }
    else if (totalMin >= 12 * 60 && totalMin <= 18 * 60)
    {
        showPeriodOfTime = @"下午";
    }
    else if ((totalMin > 18 * 60 && totalMin <= (23 * 60 + 59)) || totalMin == 0)
    {
        showPeriodOfTime = @"晚上";
    }
    return showPeriodOfTime;
}

+ (NSString *)weekdayStr:(NSInteger)dayOfWeek
{
    static NSDictionary *daysOfWeekDict = nil;
    daysOfWeekDict = @{@(1):@"星期日",
                       @(2):@"星期一",
                       @(3):@"星期二",
                       @(4):@"星期三",
                       @(5):@"星期四",
                       @(6):@"星期五",
                       @(7):@"星期六",};
    return [daysOfWeekDict objectForKey:@(dayOfWeek)];
}

#pragma mark - 用户昵称
+ (NSString *)showNick:(NSString *)uid inSession:(NIMSession *)session
{
    NSString *nickname = nil;
    switch (session.sessionType) {
        case NIMSessionTypeTeam:
        {
            NIMTeamMember *member = [[NIMSDK sharedSDK].teamManager teamMember:uid inTeam:session.sessionId];
            nickname = member.nickname;
        }
            break;
            
        default:
        {
            WTIMInfo *info = [[WTIMKit sharedKit] infoByUser:uid session:session];
            nickname = info.showName;
        }
            break;
    }
    return nickname;
}

#pragma mark - 会话列表消息显示
+ (NSString *)messageContent:(NIMMessage *)lastMessage
{
    NSString *text = @"";
    switch (lastMessage.messageType) {
        case NIMMessageTypeText:
            text = lastMessage.text;
            break;
        case NIMMessageTypeImage:
            text = @"[图片]";
            break;
        case NIMMessageTypeAudio:
            text = @"[语音]";
            break;
        case NIMMessageTypeVideo:
            text = @"[视频]";
            break;
        
        case NIMMessageTypeNotification://通知类型
            text = lastMessage.text;
            break;
        case NIMMessageTypeTip://提醒类型
            text = lastMessage.text;
            break;
        case NIMMessageTypeCustom://自定义消息
        {
            NIMCustomObject *customObject = (NIMCustomObject *)lastMessage.messageObject;
            if ([customObject.attachment isKindOfClass:[WTChartletModel class]])
            {
                text = @"[贴图]";
            }
            else if ([customObject.attachment isKindOfClass:[WTChatGoodsModel class]])
            {
                text = @"[商品]";
            }
            else if ([customObject.attachment isKindOfClass:[WTChatOrderModel class]])
            {
                text = @"[订单]";
            }
            else
            {
                text = @"未知消息";
            }
        }
            break;
            
        default:
            text = @"[未知消息]";
            break;
    }
    if (lastMessage.session.sessionType == NIMSessionTypeP2P || lastMessage.messageType == NIMMessageTypeTip)
    {
        return text;
    }
    else
    {
        NSString *from = lastMessage.from;
        NSString *nickName = [WTSessionUtil showNick:from inSession:lastMessage.session];
        return nickName.length ? [nickName stringByAppendingFormat:@" : %@",text] : @"";
    }
}

+ (NSString *)tipOnMessageRevoked:(NIMRevokeMessageNotification *)notificaton
{
    NSString *fromUid = nil;
    NIMSession *session = nil;
    NSString *tip = @"";
    BOOL isFromMe = NO;
    if([notificaton isKindOfClass:[NIMRevokeMessageNotification class]])
    {
        fromUid = [notificaton messageFromUserId];
        session = [notificaton session];
        isFromMe = [fromUid isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
        
    }
    else if(!notificaton)
    {
        isFromMe = YES;
    }
    else
    {
        assert(0);
    }
    if (isFromMe)
    {
        tip = @"你";
    }
    else
    {
        switch (session.sessionType) {
            case NIMSessionTypeP2P:
                tip = @"对方";
                break;
            case NIMSessionTypeTeam:
            {
                NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:session.sessionId];
                NIMTeamMember *member = [[NIMSDK sharedSDK].teamManager teamMember:fromUid inTeam:session.sessionId];
                if ([fromUid isEqualToString:team.owner])
                {
                    tip = @"群主";
                }
                else if(member.type == NIMTeamMemberTypeManager)
                {
                    tip = @"管理员";
                }
                WTIMInfo *info = [[WTIMKit sharedKit] infoByUser:fromUid session:session];
                tip = [tip stringByAppendingString:info.showName];
            }
                break;
            default:
                break;
        }
    }
    return [NSString stringWithFormat:@"%@撤回了一条消息",tip];
}

#pragma mark - 订单状态
+ (NSString *)matchOrderState:(NSInteger)orderState
{
    NSString *result = nil;
    switch (orderState) {
        case 0:
            result = @"订单状态：待支付";
            break;
        case 1:
            result = @"订单状态：待发货";
            break;
        case 2:
            result = @"订单状态：待收货";
            break;
        case 3:
            result = @"订单状态：交易完成";
            break;
        case 4:
            result = @"订单状态：交易取消";
            break;
            
        default:
            result = @"订单状态：未知";
            break;
    }
    return result;
}

#pragma mark - 图片尺寸
+ (CGSize)contentSizeWithMessage:(NIMMessage *)message
{
    CGSize resultSize = CGSizeZero;
    CGFloat attachmentImageMinWidth = (SCREEN_WIDTH / 4.0);
    CGFloat attachmentImageMinHeight = (SCREEN_WIDTH / 4.0);
    CGFloat attachmemtImageMaxWidth = (SCREEN_WIDTH - 184);
    CGFloat attachmentImageMaxHeight = (SCREEN_WIDTH - 184);
    switch (message.messageType) {
        case NIMMessageTypeImage:
        {
            NIMImageObject *imageObject = (NIMImageObject*)message.messageObject;
            
            CGSize imageSize;
            if (!CGSizeEqualToSize(imageObject.size, CGSizeZero))
            {
                imageSize = imageObject.size;
            }
            else
            {
                UIImage *image = [UIImage imageWithContentsOfFile:imageObject.thumbPath];
                imageSize = image ? image.size : CGSizeZero;
            }
            
            resultSize = [WTSessionUtil sizeWithImageOriginSize:imageSize minSize:CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight) maxSize:CGSizeMake(attachmemtImageMaxWidth, attachmentImageMaxHeight)];
        }
            break;
        case NIMMessageTypeVideo:
        {
            NIMVideoObject *videoObject = (NIMVideoObject *)message.messageObject;
            
            CGSize videSize = CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight);
            if (!CGSizeEqualToSize(videoObject.coverSize, CGSizeZero))
            {
                videSize = [WTSessionUtil sizeWithImageOriginSize:videoObject.coverSize minSize:CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight) maxSize:CGSizeMake(attachmemtImageMaxWidth, attachmentImageMaxHeight)];
            }
            
            resultSize = videSize;
        }
            break;
            
        default:
            break;
    }
    
    
    return resultSize;
}

+ (CGSize)sizeWithImageOriginSize:(CGSize)originSize
                          minSize:(CGSize)imageMinSize
                          maxSize:(CGSize)imageMaxSiz
{
    CGSize size;
    NSInteger imageWidth = originSize.width ,imageHeight = originSize.height;
    NSInteger imageMinWidth = imageMinSize.width, imageMinHeight = imageMinSize.height;
    NSInteger imageMaxWidth = imageMaxSiz.width,  imageMaxHeight = imageMaxSiz.height;
    if (imageWidth > imageHeight) //宽图
    {
        size.height = imageMinHeight;
        size.width = imageWidth * imageMinHeight / imageHeight;
        if (size.width > imageMaxWidth)
        {
            size.width = imageMaxWidth;
        }
    }
    else if(imageWidth < imageHeight)//高图
    {
        size.width = imageMinWidth;
        size.height = imageHeight * imageMinWidth / imageWidth;
        if (size.height > imageMaxHeight)
        {
            size.height = imageMaxHeight;
        }
    }
    else//方图
    {
        if (imageWidth > imageMaxWidth)
        {
            size.width = imageMaxWidth;
            size.height = imageMaxHeight;
        }
        else if(imageWidth > imageMinWidth)
        {
            size.width = imageWidth;
            size.height = imageHeight;
        }
        else
        {
            size.width = imageMinWidth;
            size.height = imageMinHeight;
        }
    }
    return size;
}

+ (CGSize)matchAudioDuration:(NIMMessage *)message
{
    NIMAudioObject *audioObject = (NIMAudioObject *)message.messageObject;
    NSInteger duration = audioObject.duration;
    CGFloat value = 2 * atan((duration / 1000.0 - 1) / 10.0) / M_PI;
    NSInteger audioMinWidth = 60;
    NSInteger audioMaxWidth = SCREEN_WIDTH - 120 - 74;
    return CGSizeMake((audioMaxWidth - audioMinWidth) * value + audioMinWidth, 40);
}

@end
