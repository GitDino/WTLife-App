//
//  NSDictionary+WT.h
//  wutong
//
//  Created by 魏欣宇 on 2018/7/31.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WT)

+ (NSDictionary *)dictWithJsonStr:(NSString *)jsonStr;

- (NSInteger)jsonInteger:(NSString *)key;

- (NSDictionary *)jsonDict:(NSString *)key;

- (NSString *)jsonString:(NSString *)key;

@end
