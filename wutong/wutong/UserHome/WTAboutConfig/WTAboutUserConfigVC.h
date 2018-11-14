//
//  WTAboutUserConfigVC.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^popBlock)(NSString *aliasName, NSString *remtel);

@interface WTAboutUserConfigVC : UIViewController

@property (nonatomic, copy) popBlock popBlock;
@property (nonatomic, copy) NSString *imAccount;
@property (nonatomic, copy) NSString *uid;

@end
