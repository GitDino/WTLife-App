//
//  WTContactDataMember.m
//  wutong
//
//  Created by 魏欣宇 on 2018/9/19.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTContactDataMember.h"
#import "WTIMInfo.h"
#import "WTSpellingCenter.h"

@implementation WTContactDataMember

- (CGFloat)uiHeight
{
    return 50.0;
}

- (NSString *)vcName
{
    return nil;
}

- (NSString *)reuseId
{
    return @"";
}

- (NSString *)cellName
{
    return @"";
}

- (NSString *)badge
{
    return @"";
}

- (NSString *)groupTitle
{
    NSString *title = [[WTSpellingCenter sharedCenter] firstLetter:self.info.showName].capitalizedString;
    unichar character = [title characterAtIndex:0];
    if (character >= 'A' && character <= 'Z')
    {
        return title;
    }
    else
    {
        return @"#";
    }
}

- (NSString *)userId
{
    return self.info.infoID;
}

- (UIImage *)icon
{
    return self.info.avatarImage;
}

- (NSString *)avatarUrl
{
    return self.info.avatarURL;
}

- (NSString *)memberId
{
    return self.info.infoID;
}

- (NSString *)showName
{
    return self.info.showName;
}

- (BOOL)showAccessoryView
{
    return NO;
}

- (id)sortKey
{
    return [[WTSpellingCenter sharedCenter] spellingForString:self.info.showName].shortSpelling;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]])
    {
        return NO;
    }
    return [self.info.infoID isEqualToString:[[object info] infoID]];
}

@end
