//
//  UIColor+WT.h
//  wutong
//
//  Created by 魏欣宇 on 2018/7/29.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WT)

/**
 App主色
 */
+ (instancetype)wtAppColor;

/**
 白色
 */
+ (instancetype)wtWhiteColor;

/**
 黑色
 */
+ (instancetype)wtBlackColor;

/**
 灰色
 */
+ (instancetype)wtGrayColor;

/**
 亮灰色
 */
+ (instancetype)wtLightGrayColor;

/**
 颜色适配
 */
+ (instancetype)wtColorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a;

@end
