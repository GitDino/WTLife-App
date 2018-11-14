//
//  WTShareManager.h
//  wutong
//
//  Created by 魏欣宇 on 2018/7/31.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTShareManager : NSObject

+ (void)wtShareWithTitle:(NSString *)title description:(NSString *)description thuImage:(NSString *)imageStr webURL:(NSString *)webURL completion:(void(^)(id result, NSError *error)) completion;

@end
