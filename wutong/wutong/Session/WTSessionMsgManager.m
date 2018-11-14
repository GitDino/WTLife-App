//
//  WTSessionMsgManager.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTSessionMsgManager.h"
#import "WTMessageModel.h"
#import "WTTimestampModel.h"

@interface WTSessionMsgManager ()

@property (nonatomic, strong) NIMSession *currentSession;

@property (nonatomic, strong) dispatch_queue_t messageQueue;

@property (nonatomic, strong) NSMutableDictionary *msgIdDict;

@end

@implementation WTSessionMsgManager

- (instancetype)initWithSession:(NIMSession *) session
{
    if (self = [super init])
    {
        _currentSession = session;
        _items = [NSMutableArray array];
        _msgIdDict = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Public Cycle
- (void)resetMessages:(void(^)(NSUInteger count)) handler
{
    NSArray<NIMMessage *> *messages = [[NIMSDK sharedSDK].conversationManager messagesInSession:self.currentSession message:nil limit:15];
    [self appendMessageModels:[self modelsWithMessages:messages]];
    if (handler)
    {
        handler(messages.count);
    }
}

- (void)addNewMessages:(NSArray *)messages
{
    [self appendMessageModels:[self modelsWithMessages:messages]];
}

- (void)deleteMessage:(NIMMessage *)message
{
    WTMessageModel *model = [self findModel:message];
    NSInteger delTimeIndex = -1;
    NSInteger delMsgIndex = [self.items indexOfObject:model];
    if (delMsgIndex > 0)
    {
        BOOL delMsgIsSingle = (delMsgIndex == self.items.count-1 || [self.items[delMsgIndex + 1] isKindOfClass:[WTTimestampModel class]]);
        if ([self.items[delMsgIndex - 1] isKindOfClass:[WTTimestampModel class]] && delMsgIsSingle)
        {
            delTimeIndex = delMsgIndex - 1;
            [self.items removeObjectAtIndex:delTimeIndex];
        }
    }
    if (delMsgIndex > -1)
    {
        [self.items removeObject:model];
        [_msgIdDict removeObjectForKey:model.message.messageId];
    }
}

- (void)updateMessage:(NIMMessage *)message
{
    WTMessageModel *model = [self findModel:message];
    if (model)
    {
        NSInteger index = [self indexAtModelArray:model];
        [self.items replaceObjectAtIndex:index withObject:model];
    }
}

- (void)insertTipMessages:(NSArray *)messages
{
    NSMutableArray *models = [NSMutableArray array];
    for (NIMMessage *message in models)
    {
        WTMessageModel *model = [[WTMessageModel alloc] initWithMessage:message];
        [models addObject:model];
    }
    NSArray *sortModels = [models sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        WTMessageModel *first = obj1;
        WTMessageModel *second = obj2;
        return first.message.timestamp < second.message.timestamp ? NSOrderedAscending : NSOrderedDescending;
    }];
    for (WTMessageModel *model in sortModels)
    {
        if ([self modelIsExist:model])
        {
            continue;
        }
        NSInteger i = [self findInsertPoistion:self.items model:model];
        [self insertMessageModel:model index:i];
    }
}

- (void)loadHistoryMessagesWithComplete:(void(^)(NSUInteger count)) handler
{
    if (self.items.count != 0)
    {
        __block WTMessageModel *currentOldMsg = nil;
        [self.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[WTMessageModel class]])
            {
                currentOldMsg = (WTMessageModel *)obj;
                *stop = YES;
            }
        }];
        NSArray<NIMMessage *> *messages = [[NIMSDK sharedSDK].conversationManager messagesInSession:self.currentSession message:currentOldMsg.message limit:15];
        [self insertMessages:messages];
        if (handler)
        {
            handler(messages.count);
        }
    }
}


#pragma mark - Private Cycle
- (NSArray *)appendMessageModels:(NSArray *)models
{
    if (!models.count)
    {
        return @[];
    }
    NSMutableArray *append = [NSMutableArray array];
    for (WTMessageModel *model in models)
    {
        if ([self modelIsExist:model])
        {
            continue;
        }
        NSArray *result = [self insertMessageModel:model index:self.items.count];
        [append addObjectsFromArray:result];
    }
    return append;
}

- (NSArray<WTMessageModel *> *)modelsWithMessages:(NSArray<NIMMessage *> *)messages
{
    NSMutableArray *array = [NSMutableArray array];
    for (NIMMessage *message in messages)
    {
        WTMessageModel *model = [[WTMessageModel alloc] initWithMessage:message];
        [array addObject:model];
    }
    return array;
}

- (NSArray *)insertMessageModel:(WTMessageModel *)model index:(NSInteger)index
{
    NSMutableArray *inserts = [NSMutableArray array];
    if ([self shouldInsertTimestamp:model])
    {
        WTTimestampModel *timeModel = [[WTTimestampModel alloc] initWithTime:model.message.timestamp];
        [self.items insertObject:timeModel atIndex:index];
        [inserts addObject:@(index)];
        index ++;
    }
    [self.items insertObject:model atIndex:index];
    [self.msgIdDict setObject:model forKey:model.message.messageId];
    [inserts addObject:@(index)];
    return inserts;
}

- (void)insertMessages:(NSArray *)messages
{
    for (NIMMessage *message in messages.reverseObjectEnumerator.allObjects)
    {
        [self insertMessage:message];
    }
}

- (void)insertMessage:(NIMMessage *)message
{
    WTMessageModel *model = [[WTMessageModel alloc] initWithMessage:message];
    if ([self modelIsExist:model])
    {
        return;
    }
    NSTimeInterval firstTimeInterval = [self firstTimeInterval];
    if (firstTimeInterval && firstTimeInterval - model.message.timestamp < 300)
    {
        if ([self.items.firstObject isKindOfClass:[WTTimestampModel class]])
        {
            [self.items removeObjectAtIndex:0];
        }
    }
    [self.items insertObject:model atIndex:0];
    WTTimestampModel *timeModel = [[WTTimestampModel alloc] initWithTime:model.message.timestamp];
    [self.items insertObject:timeModel atIndex:0];
    [self.msgIdDict setObject:model forKey:model.message.messageId];
}

- (WTMessageModel *)findModel:(NIMMessage *)message
{
    WTMessageModel *model;
    for (WTMessageModel *item in self.items.reverseObjectEnumerator.allObjects)
    {
        if ([item isKindOfClass:[WTMessageModel class]] && [item.message.messageId isEqual:message.messageId])
        {
            model = item;
            model.message = message;
        }
    }
    return model;
}

- (NSInteger)indexAtModelArray:(WTMessageModel *)model
{
    __block NSInteger index = -1;
    if (![self.msgIdDict objectForKey:model.message.messageId])
    {
        return index;
    }
    [self.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[WTMessageModel class]])
        {
            if ([model isEqual:obj])
            {
                index = idx;
                *stop = YES;
            }
        }
    }];
    return index;
}

- (BOOL)modelIsExist:(WTMessageModel *)model
{
    return [_msgIdDict objectForKey:model.message.messageId] != nil;
}

- (BOOL)shouldInsertTimestamp:(WTMessageModel *)model
{
    WTMessageModel *lastModel = self.items.lastObject;
    NSTimeInterval lastTimeInterval = lastModel.message.timestamp;
    return model.message.timestamp - lastTimeInterval > 300;
}

- (NSTimeInterval)firstTimeInterval
{
    if (!self.items.count)
    {
        return 0;
    }
    WTMessageModel *model = self.items[1];
    return model.message.timestamp;
}

- (NSInteger)findInsertPoistion:(NSArray *)array model:(WTMessageModel *)model
{
    if (array.count == 0)
    {
        return 0;
    }
    if (array.count == 1)
    {
        WTMessageModel *obj = array.firstObject;
        NSInteger index = [self.items indexOfObject:obj];
        return obj.message.timestamp > model.message.timestamp ? index : index + 1;
    }
    NSInteger sep = (array.count + 1) / 2;
    WTMessageModel *center = array[sep];
    NSTimeInterval timestamp = center.message.timestamp;
    NSArray *half;
    if (timestamp < model.message.timestamp)
    {
        half = [array subarrayWithRange:NSMakeRange(sep, array.count - sep)];
    }
    else
    {
        half = [array subarrayWithRange:NSMakeRange(0, sep)];
    }
    return [self findInsertPoistion:half model:model];
}

@end
