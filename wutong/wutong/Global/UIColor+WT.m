//
//  UIColor+WT.m
//  wutong
//
//  Created by 魏欣宇 on 2018/7/29.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "UIColor+WT.h"

@implementation UIColor (WT)

+ (instancetype)wtAppColor
{
    return [UIColor colorWithRed:255/255.0 green:75/255.0 blue:46/255.0 alpha:1.0];
}

+ (instancetype)wtWhiteColor
{
    return [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
}

+ (instancetype)wtBlackColor
{
    return [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1.0];
}

+ (instancetype)wtGrayColor
{
    return [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0];
}

+ (instancetype)wtLightGrayColor
{
    return [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
}

+ (instancetype)wtColorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

@end
