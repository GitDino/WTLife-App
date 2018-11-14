//
//  WTWebViewConfiguration.m
//  wutong
//
//  Created by 魏欣宇 on 2018/7/30.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTWebViewConfiguration.h"

@implementation WTWebViewConfiguration

- (instancetype)init
{
    if (self = [super init])
    {
        self.applicationNameForUserAgent = @"wtsh_ios";//Mobile(mrhs_ios)
    }
    return self;
}

@end
