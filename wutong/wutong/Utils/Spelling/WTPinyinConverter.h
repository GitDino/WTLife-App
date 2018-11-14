//
//  WTPinyinConverter.h
//  wutong
//
//  Created by 魏欣宇 on 2018/9/19.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTPinyinConverter : NSObject

+ (WTPinyinConverter *)sharedInstance;

- (NSString *)toPinyin:(NSString *)source;

@end
