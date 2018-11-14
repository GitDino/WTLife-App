//
//  WTHomeToolBar.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapSendMessageBlock)(void);

@interface WTHomeToolBar : UIView

@property (nonatomic, copy) tapSendMessageBlock tapSendMessageBlock;

+ (instancetype)homeToolBar;

@end
