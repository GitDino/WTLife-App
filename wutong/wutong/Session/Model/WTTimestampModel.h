//
//  WTTimestampModel.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTTimestampModel : NSObject

@property (nonatomic, assign) NSTimeInterval messageTime;

@property (nonatomic, copy) NSString *timeResult;

@property (nonatomic, assign) CGSize timeSize;

@property (nonatomic, assign) CGFloat cellHeight;

- (instancetype)initWithTime:(NSTimeInterval)time;

@end
