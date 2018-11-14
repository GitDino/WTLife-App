//
//  WTAppVersionAPI.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^resultBlock)(NSDictionary *object);

@interface WTAppVersionAPI : NSObject

/**
 获取当前服务器版本

 @param resultBlock 结果回掉
 */
+ (void)obtainCurrentVersionWithResultBlock:(resultBlock)resultBlock;

@end
