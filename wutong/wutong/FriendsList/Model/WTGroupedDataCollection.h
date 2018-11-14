//
//  WTGroupedDataCollection.h
//  wutong
//
//  Created by 魏欣宇 on 2018/9/19.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WTGroupMemberProtocol <NSObject>

- (NSString *)groupTitle;
- (NSString *)memberId;
- (id)sortKey;

@end

@interface WTGroupedDataCollection : NSObject

@property (nonatomic, strong) NSArray *members;
@property (nonatomic, copy) NSComparator groupTitleComparator;
@property (nonatomic, copy) NSComparator groupMemberComparator;
@property (nonatomic, readonly) NSArray *sortedGroupTitles;

- (void)addGroupMember:(id<WTGroupMemberProtocol>)member;

- (void)removeGroupMember:(id<WTGroupMemberProtocol>)member;

- (void)addGroupAboveWithTitle:(NSString *)title members:(NSArray *)members;

- (NSString *)titleOfGroup:(NSInteger)groupIndex;

- (NSArray *)membersOfGroup:(NSInteger)groupIndex;

- (id<WTGroupMemberProtocol>)memberOfIndex:(NSIndexPath *)indexPath;

- (id<WTGroupMemberProtocol>)memberOfId:(NSString *)uid;

- (NSInteger)groupCount;

- (NSInteger)memberCountOfGroup:(NSInteger)groupIndex;

@end
