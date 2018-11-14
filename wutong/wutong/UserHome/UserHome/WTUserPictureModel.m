//
//  WTUserPictureModel.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTUserPictureModel.h"
#import "WTTagModel.h"

@implementation WTUserPictureModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"sysTag" : [WTTagModel class], @"defTags" : [WTTagModel class]};
}

@end
