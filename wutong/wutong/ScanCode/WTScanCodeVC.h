//
//  WTScanCodeVC.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/1.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^codeCompleteBlock)(NSString *url);

@interface WTScanCodeVC : UIViewController

@property (nonatomic, copy) codeCompleteBlock codeCompleteBlock;

@end
