//
//  WTUploadImageAPI.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^resultBlock)(NSDictionary *object);

@interface WTUploadImageAPI : NSObject

/**
 上传图片
 
 @param resultBlock 结果回掉
 */
+ (void)uploadImage:(UIImage *)picture resultBlock:(resultBlock)resultBlock;

@end
