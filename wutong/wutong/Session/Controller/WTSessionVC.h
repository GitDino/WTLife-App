//
//  WTSessionVC.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/6/18.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTSessionVC : UIViewController

@property (nonatomic, strong) NIMSession *session;

@property (nonatomic, assign) BOOL isPush;

- (instancetype)initWithSession:(NIMSession *) session;

@end
