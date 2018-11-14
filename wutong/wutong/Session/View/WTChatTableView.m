//
//  WTChatTableView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTChatTableView.h"
#import "WTMessageCell.h"
#import "WTTimestampModel.h"
#import "WTMessageModel.h"

@interface WTChatTableView () <UITableViewDataSource, UITableViewDelegate, WTMessageCellDelegate>

@property (nonatomic, strong) NSMutableArray *messagesArray;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation WTChatTableView

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.estimatedRowHeight = 0.0;
        
        [self addGestureRecognizer:self.tapGesture];
        
        _messagesArray = [NSMutableArray array];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(self.contentSize, CGSizeZero))
    {
        if (contentSize.height > self.contentSize.height)
        {
            CGPoint offset = self.contentOffset;
            offset.y += contentSize.height - self.contentSize.height;
            self.contentOffset = offset;
        }
    }
    [super setContentSize:contentSize];
}

#pragma mark - Public Cycle
- (void)refreshMessages:(NSMutableArray *)messages
{
    if (self.messagesArray == nil)
    {
        self.messagesArray = messages;
    }
    else
    {
        [self.messagesArray removeAllObjects];
        [self.messagesArray addObjectsFromArray:messages];
    }
    [self reloadData];
}

#pragma mark - Event Cycle
- (void)onTapTableView
{
    if ([self.interactor respondsToSelector:@selector(onTapResignFirstResponder)])
    {
        [self.interactor onTapResignFirstResponder];
    }
}

#pragma mark - UITableViewDataSource数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTMessageCell *cell = [WTMessageCell messageCellWithTableView:tableView];
    cell.delegate = self;
    if ([self.messagesArray[indexPath.row] isKindOfClass:[WTTimestampModel class]])
    {
        cell.timestampModel = self.messagesArray[indexPath.row];
    }
    else if ([self.messagesArray[indexPath.row] isKindOfClass:[WTMessageModel class]])
    {
        cell.messageModel = self.messagesArray[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = [self.messagesArray[indexPath.row] cellHeight];
    return result;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.interactor respondsToSelector:@selector(didScrollOffetY:)])
    {
        [self.interactor didScrollOffetY:scrollView.contentOffset.y];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.interactor respondsToSelector:@selector(onTapResignFirstResponder)])
    {
        [self.interactor onTapResignFirstResponder];
    }
}

#pragma mark - WTMessageCellDelegate代理方法
- (void)onTapHeadIconWithSessionId:(NSString *)sessionId
{
    if ([self.interactor respondsToSelector:@selector(onTapHeadIconWithSessionId:)])
    {
        [self.interactor onTapHeadIconWithSessionId:sessionId];
    }
}

- (void)onRetryMessage:(NIMMessage *)message
{
    if ([self.interactor respondsToSelector:@selector(onRetryMessage:)])
    {
        [self.interactor onRetryMessage:message];
    }
}

- (void)onDeleteMessage:(NIMMessage *)message
{
    if ([self.interactor respondsToSelector:@selector(onDeleteMessage:)])
    {
        [self.interactor onDeleteMessage:message];
    }
}

- (void)onRevokeMessage:(NIMMessage *)message
{
    if ([self.interactor respondsToSelector:@selector(onRevokeMessage:)])
    {
        [self.interactor onRevokeMessage:message];
    }
}

- (void)onTapTextMessage:(NIMMessage *)message
{
    if ([self.interactor respondsToSelector:@selector(onTapTextMessage:)])
    {
        [self.interactor onTapTextMessage:message];
    }
}

- (void)onTapImageMessage:(NIMMessage *)message bubbleImage:(WTBubbleImageView *)bubbleImage
{
    if ([self.interactor respondsToSelector:@selector(onTapImageMessage:bubbleImage:)])
    {
        [self.interactor onTapImageMessage:message bubbleImage:bubbleImage];
    }
}

- (void)onTapAudioMessage:(NIMMessage *)message
{
    if ([self.interactor respondsToSelector:@selector(onTapAudioMessage:)])
    {
        [self.interactor onTapAudioMessage:message];
    }
}

- (void)onTapVideoMessage:(NIMMessage *)message
{
    if ([self.interactor respondsToSelector:@selector(onTapVideoMessage:)])
    {
        [self.interactor onTapVideoMessage:message];
    }
}

- (void)onTapGoodsMessage:(NIMMessage *)message
{
    if ([self.interactor respondsToSelector:@selector(onTapGoodsMessage:)])
    {
        [self.interactor onTapGoodsMessage:message];
    }
}

- (void)onTapOrderMessage:(NIMMessage *)message
{
    if ([self.interactor respondsToSelector:@selector(onTapOrderMessage:)])
    {
        [self.interactor onTapOrderMessage:message];
    }
}

#pragma mark - Getter Cycle
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture)
    {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapTableView)];
    }
    return _tapGesture;
}

@end
