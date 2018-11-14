//
//  WTSessionListCell.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/6/27.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTSessionListCell.h"
#import "WTSession.h"
#import "WTSessionUtil.h"
#import "WTIMKit.h"

@interface WTSessionListCell ()

@property (nonatomic, strong) WTIMInfo *userInfo;

/**
 头像
 */
@property (nonatomic, strong) UIImageView *iconImage;

/**
 昵称
 */
@property (nonatomic, strong) UILabel *nicknameLabel;

/**
 最新消息
 */
@property (nonatomic, strong) UILabel *contentLabel;

/**
 日期
 */
@property (nonatomic, strong) UILabel *dateLabel;

/**
 未读数
 */
@property (nonatomic, strong) UILabel *redCountLabel;

@end

@implementation WTSessionListCell

#pragma mark - Life Cycle
+ (instancetype)sessionListCellWithTableView:(UITableView *) tableView
{
    static NSString *ID = @"WTSessionListCell";
    WTSessionListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[WTSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 50, 50)];
        _iconImage.layer.masksToBounds = YES;
        _iconImage.layer.cornerRadius = 5.0;
        [self.contentView addSubview:_iconImage];
        
        _redCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImage.wt_right - 8, _iconImage.wt_top - 8, 16, 16)];
        _redCountLabel.layer.masksToBounds = YES;
        _redCountLabel.layer.cornerRadius = 8.0;
        _redCountLabel.backgroundColor = [UIColor redColor];
        _redCountLabel.font = [UIFont systemFontOfSize:12];
        _redCountLabel.textAlignment = NSTextAlignmentCenter;
        _redCountLabel.textColor = [UIColor whiteColor];
        _redCountLabel.text = @"9";
        [self.contentView addSubview:_redCountLabel];
        
        _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImage.wt_right + 10, _iconImage.wt_top, [UIScreen mainScreen].bounds.size.width - 160, 25)];
        _nicknameLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_nicknameLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nicknameLabel.wt_left, _nicknameLabel.wt_bottom, [UIScreen mainScreen].bounds.size.width - 90, 25)];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = [UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.0];
        [self.contentView addSubview:_contentLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 70 - 10, 12, 70, 15)];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

#pragma mark - Setter Cycle
- (void)setWtSession:(WTSession *)wtSession
{
    _wtSession = wtSession;
    
    NIMRecentSession *recentSession = _wtSession.recentSession;
    
    _userInfo = [[WTIMKit sharedKit] infoByUser:recentSession.session.sessionId session:recentSession.session];
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatarURL] placeholderImage:[UIImage imageNamed:@"icon_default_head"]];
    
    _redCountLabel.hidden = recentSession.unreadCount == 0;
    _redCountLabel.text = [NSString stringWithFormat:@"%zd", recentSession.unreadCount];
    
    _nicknameLabel.text = [WTSessionUtil showNick:recentSession.session.sessionId inSession:recentSession.session];
    _contentLabel.text = [WTSessionUtil messageContent:recentSession.lastMessage];
    _dateLabel.text = [WTSessionUtil showTime:recentSession.lastMessage.timestamp detail:NO];
}

@end
