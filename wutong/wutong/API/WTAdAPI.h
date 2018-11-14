//
//  WTAdAPI.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^resultBlock)(NSDictionary *object);

@interface WTAdAPI : NSObject

/**
 获取广告业数据

 @param resultBlock 结果回掉
 */
+ (void)obtainAdDataWithResultBlock:(resultBlock)resultBlock;

@end
