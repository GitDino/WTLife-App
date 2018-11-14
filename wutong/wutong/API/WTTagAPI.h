//
//  WTTagAPI.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^resultBlock)(NSDictionary *object);

@interface WTTagAPI : NSObject

/**
 添加自定义标签

 @param tags 标签
 @param uid 用户ID
 @param resultBlock 结果回掉
 */
+ (void)addCustomTagName:(NSString *)tags withUid:(NSString *)uid resultBlock:(resultBlock)resultBlock;

@end
