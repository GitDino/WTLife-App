//
//  WTChatCustomWebViewVC.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sendCompleteBlock)(id object);

@interface WTChatCustomWebViewVC : UIViewController

@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, copy) sendCompleteBlock sendCompleteBlock;

@end
