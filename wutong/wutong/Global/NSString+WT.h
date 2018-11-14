//
//  NSString+WT.h
//  wutong
//
//  Created by 魏欣宇 on 2018/7/31.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WT)

/**
 判断字符串是否为空
 */
+ (BOOL)isBlankString:(NSString *)str;

/**
 计算字符串实际尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 获取url中的参数并返回
 */
+ (NSArray *)getParamsWithUrlString:(NSString *)urlString;

@end
