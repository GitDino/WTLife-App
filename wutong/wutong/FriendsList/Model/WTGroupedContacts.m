//
//  WTGroupedContacts.m
//  wutong
//
//  Created by 魏欣宇 on 2018/9/19.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTGroupedContacts.h"
#import "WTContactDataMember.h"
#import "WTIMKit.h"

@implementation WTGroupedContacts

- (instancetype)init
{
    if(self = [super init])
    {
        self.groupTitleComparator = ^NSComparisonResult(NSString *title1, NSString *title2) {
            if ([title1 isEqualToString:@"#"])
            {
                return NSOrderedDescending;
            }
            if ([title2 isEqualToString:@"#"])
            {
                return NSOrderedAscending;
            }
            return [title1 compare:title2];
        };
        self.groupMemberComparator = ^NSComparisonResult(NSString *key1, NSString *key2) {
            return [key1 compare:key2];
        };
        [self update];
    }
    return self;
}

- (void)update
{
    NSMutableArray *contacts = [NSMutableArray array];
    for (NIMUser *user in [NIMSDK sharedSDK].userManager.myFriends)
    {
        WTIMInfo *info = [[WTIMKit sharedKit] infoByUser:user.userId session:nil];
        WTContactDataMember *contact = [[WTContactDataMember alloc] init];
        contact.info = info;
        [contacts addObject:contact];
    }
    [self setMembers:contacts];
}

@end
